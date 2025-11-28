const SerialPort = require("serialport").SerialPort;
const ReadlineParser = require("@serialport/parser-readline").ReadlineParser;
const express = require("express");
const WebSocket = require("ws");

const PORT = "/dev/ttyUSB0";
const BAUDRATE = 115200;

// ---- Serial Port Setup ----
const port = new SerialPort({
    path: PORT,
    baudRate: BAUDRATE
});
const parser = port.pipe(new ReadlineParser());

port.on("open", () => {
    console.log("Serial port opened:", PORT);
});

// ---- Web Server + WebSocket Setup ----
const app = express();
const httpServer = app.listen(8080, () =>
    console.log("Web UI: http://localhost:8080")
);

app.use(express.static("./public"));

const wss = new WebSocket.Server({ server: httpServer });

function broadcast(obj) {
    const msg = JSON.stringify(obj);
    wss.clients.forEach(c => {
        if (c.readyState === WebSocket.OPEN) c.send(msg);
    });
}

// ---- Handle Commands From Browser ----
wss.on("connection", ws => {
    ws.on("message", msg => {
        try {
            const data = JSON.parse(msg);
            if (data.cmd) {
                console.log("TX:", data.cmd);
                port.write(data.cmd + "\n");
            }
        } catch (e) {}
    });
});

// ---- Parse LDS Lines ----
parser.on("data", line => {
    line = line.trim();

    const parts = line.split(",");
    if (parts.length !== 4) return;

    const angle = Number(parts[0]);
    const distMM = Number(parts[1]);
    const err = parts[3];

    if (err !== "0" || distMM === 0) return;

    broadcast({
        angle,
        dist: distMM / 1000
    });
});
