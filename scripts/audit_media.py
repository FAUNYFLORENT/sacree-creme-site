from pathlib import Path
import subprocess,json,csv,os
ROOT=Path(__file__).resolve().parents[1]
MEDIA=ROOT/'public/media'
rows=[]
for p in sorted(MEDIA.rglob('*')):
    if not p.is_file() or p.suffix.lower() not in {'.mp4','.webm','.jpg'}: continue
    rel=p.relative_to(MEDIA)
    row={'file':str(rel),'size_bytes':p.stat().st_size,'size_mb':round(p.stat().st_size/1e6,3),'codec':'jpeg' if p.suffix=='.jpg' else '', 'width':'','height':'','duration_seconds':'','audio_streams':0}
    if p.suffix!='.jpg':
        data=json.loads(subprocess.check_output(['ffprobe','-v','error','-show_streams','-show_format','-of','json',str(p)],text=True))
        video=next((s for s in data.get('streams',[]) if s.get('codec_type')=='video'),{})
        row.update(codec=video.get('codec_name',''),width=video.get('width',''),height=video.get('height',''),duration_seconds=round(float(data.get('format',{}).get('duration',0)),3),audio_streams=sum(s.get('codec_type')=='audio' for s in data.get('streams',[])))
    rows.append(row)
with open(ROOT/'reports/media-manifest-final.csv','w',newline='',encoding='utf-8') as f:
    w=csv.DictWriter(f,fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
summary={'files':len(rows),'total_mb':round(sum(r['size_bytes'] for r in rows)/1e6,2),'over_10mb':[r for r in rows if r['size_bytes']>=10_000_000],'over_100mb':[r for r in rows if r['size_bytes']>=100_000_000],'with_audio':[r for r in rows if r['audio_streams']]}
(ROOT/'reports/media-audit.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:(len(v) if isinstance(v,list) else v) for k,v in summary.items()},ensure_ascii=False,indent=2))
raise SystemExit(1 if summary['over_100mb'] or summary['with_audio'] else 0)
