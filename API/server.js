const express = require('express');
const { createConnection, changeSwitch, deviceID } = require('./connect');

const app = express();
const port = 7777;

app.get('/toggle/:light', async (req, res) => {
    const light = req.params.light;
    const Luz = {
        'Central': '1',
        'Armario': '2',
        'Janela': '3'
    };

    const connection = await createConnection()

    await changeSwitch(connection, Luz, light)

    let status = await connection.getDevice(deviceID)
    status = status.params.switches
    statusRemove = status.pop()

    res.json(status)

});

app.get('/status/:device', async (req, res) => {
    const device = req.params.device;
    const connection = await createConnection()


    let status = await connection.getDevice(device)
    status = await status.params.switches
    status.forEach((item) => {
        if (item.outlet === 0) {
            item.Nome = "Central";
        } else if(item.outlet === 1) {
            item.Nome = "Armário"
        } else if(item.outlet===2) {
            item.Nome = "Janela"
        }
    })
    statusRemove = status.pop()

    res.json(status)
})

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});