const express = require ('express');
const {createConnection, changeSwitch, deviceID} = require('./connect');

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

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});