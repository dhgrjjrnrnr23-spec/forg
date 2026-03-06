const { app, BrowserWindow, dialog } = require('electron');
const path = require('path');
const { spawn } = require('child_process');

function createWindow() {
  const win = new BrowserWindow({
    width: 500,
    height: 200,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true
    }
  });

  win.loadFile('index.html');
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

// handle launch request from renderer
const { ipcMain } = require('electron');
ipcMain.handle('choose-file', async () => {
  const { canceled, filePaths } = await dialog.showOpenDialog({
    properties: ['openFile'],
    filters: [
      { name: 'Executables', extensions: ['exe','jar',''] },
      { name: 'All Files', extensions: ['*'] }
    ]
  });
  if (canceled) return null;
  return filePaths[0];
});

ipcMain.handle('launch-file', (event, filePath) => {
  if (!filePath) return { error: 'No path provided' };
  try {
    spawn(filePath, [], { detached: true, stdio: 'ignore' }).unref();
    return { success: true };
  } catch (e) {
    return { error: e.message };
  }
});