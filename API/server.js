const express = require ('express');
const {createConnection, changeSwitch} = require('./connect');

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


});

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});