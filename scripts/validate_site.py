from pathlib import Path
import re, csv, json, subprocess
ROOT=Path(__file__).resolve().parents[1]
errors=[]; warnings=[]
html=(ROOT/'index.html').read_text(encoding='utf-8')
for match in re.finditer(r'(?:src|href)="(\./[^"?#]+)',html):
    rel=match.group(1)[2:]
    p=ROOT/rel
    if not p.exists(): errors.append(f'Référence absente: {rel}')
for p in (ROOT/'public').rglob('*'):
    if p.is_file():
        size=p.stat().st_size
        if size>=100_000_000: errors.append(f'Fichier >=100 Mo: {p.relative_to(ROOT)} ({size/1e6:.1f} Mo)')
        elif size>=10_000_000: warnings.append(f'Fichier >=10 Mo: {p.relative_to(ROOT)} ({size/1e6:.1f} Mo)')
for p in (ROOT/'public/media').rglob('*.mp4') if (ROOT/'public/media').exists() else []:
    out=subprocess.check_output(['ffprobe','-v','error','-show_entries','stream=codec_type','-of','csv=p=0',str(p)],text=True)
    if 'audio' in out: errors.append(f'Piste audio interdite sur vidéo de fond: {p.relative_to(ROOT)}')
expected=[f'Plan_horizontal_concept_archi_{i}.mov' for i in range(1,10)]
with open(ROOT/'media_selection.csv',encoding='utf-8') as f:
    rows=list(csv.DictReader(f))
actual=[r['fichier'] for r in rows if r['ordre_provisoire'].isdigit()][:9]
if actual != expected: errors.append(f'Ordre architectural incorrect: {actual}')
report={'errors':errors,'warnings':warnings,'status':'PASS' if not errors else 'FAIL'}
(ROOT/'reports/validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
raise SystemExit(1 if errors else 0)
