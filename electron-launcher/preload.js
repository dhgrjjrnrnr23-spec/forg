const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
  chooseFile: () => ipcRenderer.invoke('choose-file'),
  launchFile: (path) => ipcRenderer.invoke('launch-file', path)
});