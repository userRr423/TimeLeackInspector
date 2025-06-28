
const directoryChoose = document.querySelector('#choose-directorys');
const directorySideBar = document.querySelector('#directorys');

const tringleOne = document.querySelector('#one');
const tringleTwo = document.querySelector('#two');
const tringleThree = document.querySelector('#three');

sw1 = false;
directoryChoose.addEventListener('click', () => {
    if(!sw1) {
        directorySideBar.style.display = 'none';
        tringleThree.style.transform = "rotate(180deg)";
        sw1 = true;
    }
    else {
        directorySideBar.style.display = 'block';
        tringleThree.style.transform = "rotate(360deg)";
        sw1 = false;
    }
})

const chooseOrganizations = document.querySelector('#choose-organizations');
const OrganizationsSideBar = document.querySelector('#organizations');

sw2 = false;
chooseOrganizations.addEventListener('click', () => {
    if(!sw2) {
        OrganizationsSideBar.style.display = 'none';
        tringleOne.style.transform = "rotate(180deg)";
        sw2 = true;
    }
    else {
        OrganizationsSideBar.style.display = 'block';
        sw2 = false;
        tringleOne.style.transform = "rotate(360deg)";
    }
})


const mainChoose = document.querySelector('#main-choose');
const mainSideBar = document.querySelector('#main-functional');

sw3 = false;
mainChoose.addEventListener('click', () => {
    if(!sw3) {
        mainSideBar.style.display = 'none';
        tringleTwo.style.transform = "rotate(180deg)";
        sw3 = true;
    }
    else {
        mainSideBar.style.display = 'block';
        tringleTwo.style.transform = "rotate(360deg)";
        sw3 = false;
    }
})







