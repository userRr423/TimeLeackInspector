const employInfo = document.querySelector('.employee-info-panel');
const monitoringPanel = document.querySelector('.monitoring-panel');
const about = document.querySelector('.about-employee');
const monitoring = document.querySelector('.monitoring');

//sw = false;
about.addEventListener('click', () => {
    employInfo.style.display = 'block';
    monitoringPanel.style.display = 'none';
})

monitoring.addEventListener('click', () => {
    //location.reload();
    employInfo.style.display = 'none';
    monitoringPanel.style.display = 'block';
    
})



