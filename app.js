const url = window.location.pathname;

let endpoint = "";

if (url.includes("universidad")) endpoint = "universidades";
if (url.includes("area")) endpoint = "area_conocimiento";
if (url.includes("aspecto")) endpoint = "aspecto_normativo";
if (url.includes("practica")) endpoint = "practica_estrategia";
if (url.includes("enfoque")) endpoint = "enfoque";
if (url.includes("innovacion")) endpoint = "car_innovacion";
if (url.includes("aliado")) endpoint = "aliado";

const API = "http://localhost:3000/" + endpoint;

async function cargar() {
    const res = await fetch(API);
    const data = await res.json();

    const tabla = document.getElementById("tabla");
    if (!tabla) return;

    tabla.innerHTML = "";

    data.forEach(d => {
        tabla.innerHTML += `
            <tr>
                <td>${d.id || d.nit}</td>
                <td>${d.nombre || d.gran_area || d.tipo}</td>
                <td><button onclick="eliminar('${d.id || d.nit}')">Eliminar</button></td>
            </tr>
        `;
    });
}

const form = document.getElementById("form");

if (form) {
    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        let datos = {};

        [...form.elements].forEach(el => {
            if (el.id) datos[el.id] = el.value;
        });

        await fetch(API, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(datos)
        });

        form.reset();
        cargar();
    });
}

async function eliminar(id) {
    await fetch(API + "/" + id, { method: "DELETE" });
    cargar();
}

cargar();