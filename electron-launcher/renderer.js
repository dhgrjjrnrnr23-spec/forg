const pathInput = document.getElementById('path');
const status = document.getElementById('status');

document.getElementById('browse').addEventListener('click', async () => {
  const file = await window.api.chooseFile();
  if (file) {
    pathInput.value = file;
  }
});

document.getElementById('launch').addEventListener('click', async () => {
  const file = pathInput.value;
  const result = await window.api.launchFile(file);
  if (result.error) {
    status.textContent = "Ошибка: " + result.error;
  } else {
    status.textContent = "Файл запущен";
    setTimeout(() => { status.textContent = ''; }, 3000);
  }
});