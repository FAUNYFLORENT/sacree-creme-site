const body = document.body;
const header = document.querySelector('#site-header');
const menuButton = document.querySelector('.menu-toggle');
const mobileNav = document.querySelector('#mobile-nav');
const motionButton = document.querySelector('[data-motion-toggle]');
const architectureStage = document.querySelector('[data-architecture-stage]');

const mediaBase = './public/media/architecture/';
const architectureOrder = [
  'archi-1','archi-2','archi-3','archi-4','archi-5',
  'archi-6','archi-7','archi-8','archi-9','archi-logo-exterieur'
];

window.addEventListener('scroll', () => {
  header.classList.toggle('scrolled', window.scrollY > 48);
}, { passive: true });

menuButton?.addEventListener('click', () => {
  const open = menuButton.getAttribute('aria-expanded') === 'true';
  menuButton.setAttribute('aria-expanded', String(!open));
  mobileNav.hidden = open;
});
mobileNav?.querySelectorAll('a').forEach(a => a.addEventListener('click', () => {
  mobileNav.hidden = true;
  menuButton.setAttribute('aria-expanded','false');
}));

motionButton?.addEventListener('click', () => {
  const reduced = body.classList.toggle('reduced-motion');
  motionButton.setAttribute('aria-pressed', String(reduced));
  motionButton.textContent = reduced ? 'Réactiver les animations' : 'Réduire les animations';
  document.querySelectorAll('video').forEach(video => reduced ? video.pause() : video.play().catch(() => {}));
});

const clamp = (v,min,max) => Math.min(max,Math.max(min,v));
const setVideoTime = (video, progress) => {
  if (!Number.isFinite(video.duration) || video.duration <= 0) return;
  const t = clamp(progress,0,1) * Math.max(0, video.duration - .04);
  if (Math.abs(video.currentTime - t) > .035) video.currentTime = t;
};

// Hero: la cuillère avance avec le scroll et repart en arrière si le sens s’inverse.
const heroZone = document.querySelector('[data-scrub-zone]');
const heroVideo = heroZone?.querySelector('video');
const updateHero = () => {
  if (!heroZone || !heroVideo || body.classList.contains('reduced-motion')) return;
  const rect = heroZone.parentElement.getBoundingClientRect();
  const travel = heroZone.parentElement.offsetHeight - innerHeight;
  setVideoTime(heroVideo, travel > 0 ? -rect.top / travel : 0);
};

// Storyboard architectural : ordre source natif archi_1 → archi_9 → enseigne extérieure.
if (architectureStage) {
  const video = architectureStage.querySelector('.architecture-video');
  const index = architectureStage.querySelector('.architecture-index');
  const progressBar = architectureStage.querySelector('.architecture-progress span');
  const loaded = new Map();
  let currentIndex = 0;

  const loadClip = (i) => {
    if (loaded.has(i)) return loaded.get(i);
    const v = document.createElement('video');
    v.muted = true; v.playsInline = true; v.preload = 'auto';
    v.src = `${mediaBase}${architectureOrder[i]}-scrub-gop3.mp4`;
    v.load(); loaded.set(i,v); return v;
  };
  [0,1].forEach(loadClip);

  const swapClip = (i, clipProgress) => {
    if (i !== currentIndex) {
      currentIndex = i;
      const source = loadClip(i);
      video.src = source.src;
      video.poster = `./public/media/posters/${architectureOrder[i]}.jpg`;
      video.load();
      loadClip(Math.min(i+1,architectureOrder.length-1));
      loadClip(Math.max(i-1,0));
    }
    index.textContent = `${String(i+1).padStart(2,'0')} / ${architectureOrder.length}`;
    setVideoTime(video, clipProgress);
  };

  const updateArchitecture = () => {
    if (body.classList.contains('reduced-motion')) return;
    const rect = architectureStage.getBoundingClientRect();
    const total = architectureStage.offsetHeight - innerHeight;
    const global = clamp(total > 0 ? -rect.top / total : 0,0,1);
    const raw = global * architectureOrder.length;
    const i = Math.min(architectureOrder.length-1, Math.floor(raw));
    swapClip(i, raw - i);
    progressBar.style.width = `${global*100}%`;
  };
  window.addEventListener('scroll', updateArchitecture, { passive:true });
  window.addEventListener('resize', updateArchitecture);
  video.addEventListener('loadedmetadata', updateArchitecture);
  updateArchitecture();
}

window.addEventListener('scroll', updateHero, { passive:true });
window.addEventListener('resize', updateHero);
heroVideo?.addEventListener('loadedmetadata', updateHero);
updateHero();

// Ne charge les vidéos décoratives que lorsqu’elles approchent du viewport.
const videoObserver = new IntersectionObserver(entries => {
  entries.forEach(({target,isIntersecting}) => {
    if (target.classList.contains('scrub-video') || target.classList.contains('architecture-video')) return;
    if (isIntersecting && !body.classList.contains('reduced-motion')) target.play().catch(() => {});
    else target.pause();
  });
}, { rootMargin:'240px 0px', threshold:.01 });
document.querySelectorAll('video').forEach(v => videoObserver.observe(v));

document.querySelector('[data-demo-form]')?.addEventListener('submit', event => {
  event.preventDefault();
  const note = event.currentTarget.querySelector('.form-note');
  note.textContent = 'Merci — dans ce prototype, ta demande reste locale et n’est pas envoyée.';
});
