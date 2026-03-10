
(function(){
  const toggle = document.querySelector('.nav-toggle');
  const nav = document.querySelector('.primary-nav');
  if(toggle && nav){
    toggle.addEventListener('click', ()=>{
      const open = nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(open));
    });
  }

  document.querySelectorAll('[data-filter-input]').forEach(input => {
    const target = document.querySelector(input.getAttribute('data-filter-target'));
    if(!target) return;
    const cards = Array.from(target.querySelectorAll('[data-filter-item]'));
    const apply = ()=>{
      const query = input.value.trim().toLowerCase();
      cards.forEach(card => {
        const text = card.getAttribute('data-filter-item').toLowerCase();
        card.style.display = !query || text.includes(query) ? '' : 'none';
      });
    };
    input.addEventListener('input', apply);
  });

  document.querySelectorAll('[data-filter-select]').forEach(select => {
    const target = document.querySelector(select.getAttribute('data-filter-target'));
    if(!target) return;
    const cards = Array.from(target.querySelectorAll('[data-filter-item]'));
    const apply = ()=>{
      const value = select.value;
      cards.forEach(card => {
        const group = card.getAttribute('data-group');
        card.style.display = (!value || value === 'all' || group === value) ? '' : 'none';
      });
    };
    select.addEventListener('change', apply);
  });

  document.querySelectorAll('form[data-demo-form]').forEach(form => {
    form.addEventListener('submit', (e)=>{
      e.preventDefault();
      const note = form.querySelector('.help');
      if(note) note.textContent = 'Demo form captured. In production, connect this to a CRM, ATS, or secure intake workflow.';
    });
  });
})();
