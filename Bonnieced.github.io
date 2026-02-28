<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;700&family=Dancing+Script:wght@600&display=swap" rel="stylesheet">
    <title>San Valentín - Árbol y Contador</title>

    <style>
        :root {
            --heart-size: 64px;          
            --text-size: 28px;           
            --text-color: #d60000;       
            --line-color: #d60000;       
            --line-thickness: 4px;       
        }

        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #f5e8dc;
            font-family: 'Montserrat', sans-serif;
            overflow: hidden;
            transition: background 2.5s ease;
        }

        .fade-out-element {
            opacity: 0 !important;
            transition: opacity 2s ease !important;
        }

        .bg-black { background: #000000 !important; }

        .container {
            display: flex;
            align-items: flex-end;
            gap: 12px;
            transition: transform 1.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 1.2s ease;
            z-index: 100;
        }

        .heart-main {
            position: relative;
            width: var(--heart-size);
            height: var(--heart-size);
            background: #d60000;
            transform: rotate(-45deg);
            transition: all 1.2s ease;
        }

        .heart-main::before, .heart-main::after {
            content: '';
            position: absolute;
            width: var(--heart-size);
            height: var(--heart-size);
            background: #d60000;
            border-radius: 50%;
        }
        .heart-main::before { top: -50%; left: 0; }
        .heart-main::after { left: 50%; top: 0; }

        .text {
            font-size: var(--text-size);
            font-weight: 400;
            color: var(--text-color);
            position: relative;
            transition: all 1.2s ease;
        }

        .text::after {
            content: '';
            position: absolute;
            left: 0; bottom: -5px;
            width: 100%; height: var(--line-thickness);
            background: var(--line-color);
        }

        .heart-main.to-circle { border-radius: 50%; transform: rotate(0deg) scale(1.3); }
        .heart-main.to-circle::before, .heart-main.to-circle::after { opacity: 0; }
        .text.absorb { opacity: 0; transform: translateX(-40px) scale(0.4); }

        .container.move-down {
            transform: translateY(60vh);
            opacity: 0;
        }

        .bottom-line {
            position: fixed;
            bottom: 70px;
            left: 50%;
            height: 4px;
            background: #550000;
            width: 0;
            transform: translateX(-50%);
            transition: width 1.2s ease, opacity 1.2s ease;
            opacity: 0;
        }
        .bottom-line.expand { width: calc(100% - 100px); opacity: 1; }

        .tree {
            position: fixed;
            bottom: 70px; 
            right: 20%; 
            pointer-events: none;
            z-index: 20;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .trunk {
            width: 50px; 
            height: 450px; 
            background: #6d3611;
            transform-origin: bottom center;
            transform: scaleY(0);
            clip-path: polygon(40% 0%, 60% 0%, 100% 100%, 0% 100%);
            transition: transform 3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .tree.grow .trunk { transform: scaleY(1); }

        .branch {
            position: absolute;
            width: 18px;
            height: 160px;
            background: #6d3611;
            transform-origin: bottom left;
            transform: scaleY(0);
            border-radius: 50% / 100%;
        }

        .tree.grow .branch { animation: growBranch 1s forwards; }
        
        .b1 { bottom: 80px; left: 12px; --angle: -45deg; animation-delay: 1.8s !important; }
        .b2 { bottom: 160px; left: 20px; --angle: 40deg; animation-delay: 2.1s !important; }
        .b3 { bottom: 240px; left: 12px; --angle: -35deg; animation-delay: 2.4s !important; }
        .b4 { bottom: 310px; left: 20px; --angle: 35deg; animation-delay: 2.7s !important; }
        .b5 { bottom: 370px; left: 15px; --angle: -20deg; animation-delay: 3.0s !important; }

        @keyframes growBranch {
            from { transform: rotate(var(--angle)) scaleY(0); }
            to { transform: rotate(var(--angle)) scaleY(1); }
        }

        .petal {
            position: absolute;
            width: 14px;
            height: 14px;
            transform: rotate(-45deg);
            z-index: 25;
            opacity: 0;
        }
        
        .petal.fade-in { animation: fadeInPetal 1.5s ease forwards; }

        @keyframes fadeInPetal { to { opacity: 1; } }

        .petal::before, .petal::after {
            content: ""; position: absolute;
            width: 14px; height: 14px;
            background: inherit; border-radius: 50%;
        }
        .petal::before { top: -7px; left: 0; }
        .petal::after { top: 0; left: 7px; }

        @keyframes floatLeft {
            0% { opacity: 1; transform: translate(0,0) rotate(-45deg) scale(1);}
            100% { opacity: 0; transform: translate(-180px, 200px) rotate(-90deg) scale(0.5);}
        }

        .typewriter-container {
            position: fixed;
            top: 35%;
            left: 25%;
            transform: translate(-50%, -50%);
            z-index: 50;
            opacity: 0;
            transition: opacity 1s ease;
        }

        .typewriter {
            color: #550000;
            font-size: 24px;
            line-height: 1.6;
            max-width: 400px;
            white-space: pre-line;
            font-weight: 500;
        }

        .cursor {
            display: inline-block;
            width: 2px;
            height: 24px;
            background-color: #4a3f35;
            margin-left: 5px;
            vertical-align: middle;
            animation: blink 0.7s infinite;
        }

        @keyframes blink { 0%, 100% { opacity: 1; } 50% { opacity: 0; } }

        .fake-cursor {
            position: fixed;
            width: 50px; height: 50px;
            background-image: url("cursor.gif");
            background-size: contain;
            background-repeat: no-repeat;
            pointer-events: none;
            transition: all 1.2s ease, opacity 1s ease;
            z-index: 9999;
        }

        .contador-contenedor {
            position: fixed;
            bottom: 100px; 
            left: 80px;   
            color: #550000;
            text-align: left;
            max-width: 600px;
            z-index: 60;
            opacity: 0; 
            transition: opacity 1.5s ease;
        }

        .contador-contenedor h1 { font-size: 1.5em; margin: 0 0 5px 0; font-weight: 700; }
        .tiempo { font-size: 1.1em; font-weight: 400; }
        .tiempo span { font-weight: 700; margin-right: 3px; }

        #collage-scene {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            justify-content: center;
            align-items: center;
            z-index: 200;
        }

        .contenedor-texto-collage {
            text-align: center;
            z-index: 300;
            background: rgba(0, 0, 0, 0.4);
            padding: 20px;
            border-radius: 20px;
            backdrop-filter: blur(4px);
            opacity: 0;
            animation: aparecerTexto 2.5s ease-out forwards;
        }

        .contenedor-texto-collage h1 {
            font-family: 'Dancing Script', cursive;
            font-size: 3.5rem;
            margin: 0;
            color: #ff4d6d;
        }

        .contenedor-texto-collage p {
            font-size: 1.2rem;
            letter-spacing: 2px;
            color: #ffb3c1;
        }

        @keyframes aparecerTexto {
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1); }
        }

        .colage img {
            position: absolute;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
            top: -400px;
            animation: lluvia 2s cubic-bezier(0.22, 1, 0.36, 1) forwards;
            border: 2px solid rgba(255, 255, 255, 0.1);
            width: 180px; height: 180px;
        }

        @keyframes lluvia {
            to { 
                top: var(--y); 
                left: var(--x); 
                transform: rotate(var(--r)) scale(var(--s)); 
            }
        }

        .img1 { --x: 5%;  --y: 10%; --r: -10deg; --s: 1.1; animation-delay: 0.5s; }
        .img2 { --x: 80%; --y: 5%;  --r: 15deg;  --s: 0.9; animation-delay: 1s; }
        .img3 { --x: 10%; --y: 70%; --r: 5deg;   --s: 1.2; animation-delay: 0.7s; }
        .img4 { --x: 75%; --y: 75%; --r: -12deg; --s: 1.0; animation-delay: 1.5s; }
        .img5 { --x: 40%; --y: 8%;  --r: 0deg;   --s: 0.8; animation-delay: 2s; }
        .img6 { --x: 55%; --y: 80%; --r: 8deg;   --s: 1.1; animation-delay: 1.3s; }
        .img7 { --x: 2%;  --y: 40%; --r: -5deg;  --s: 0.9; animation-delay: 1.7s; }
        .img8 { --x: 85%; --y: 45%; --r: 10deg;  --s: 1.0; animation-delay: 0.9s; }
        .c1 { --x: 25%; --y: 15%; --r: 12deg;  --s: 0.7; animation-delay: 2.3s; }
        .c2 { --x: 65%; --y: 20%; --r: -8deg;  --s: 0.6; animation-delay: 2.6s; }
        .c3 { --x: 20%; --y: 50%; --r: 15deg;  --s: 0.7; animation-delay: 2.1s; }
        .c4 { --x: 70%; --y: 55%; --r: -15deg; --s: 0.8; animation-delay: 3s; }
        .c5 { --x: 45%; --y: 65%; --r: 5deg;   --s: 0.6; animation-delay: 2.5s; }
        .c6 { --x: 35%; --y: 45%; --r: -20deg; --s: 0.7; animation-delay: 3.3s; }
        .c7 { --x: 15%; --y: 5%;  --r: 20deg;  --s: 0.5; animation-delay: 3.5s; }
        .c8 { --x: 85%; --y: 85%; --r: -5deg;  --s: 0.6; animation-delay: 2.8s; }
    </style>
</head>
<body>

    <div class="fake-cursor" id="fakeCursor"></div>

    <div id="scene-1">
        <div class="container" id="mainContainer">
            <div class="heart-main" id="mainHeart"></div>
            <div class="text" id="mainText">San Valentin</div>
        </div>

        <div class="bottom-line" id="bottomLine"></div>

        <div class="contador-contenedor" id="contador">
            <h1>Mi amor por ti comenzó hace...</h1>
            <div class="tiempo">
                <span id="dias">0</span> días 
                <span id="horas">0</span> horas 
                <span id="minutos">0</span> minutos 
                <span id="segundos">0</span> segundos
            </div>
        </div>

        <div class="typewriter-container" id="letterContainer">
            <span id="text" class="typewriter"></span>
            <span class="cursor"></span>
        </div>

        <div class="tree" id="tree">
            <div class="trunk" id="trunk"></div>
            <div class="branch b1"></div>
            <div class="branch b2"></div>
            <div class="branch b3"></div>
            <div class="branch b4"></div>
            <div class="branch b5"></div>
        </div>
    </div>

    <div id="collage-scene">
        <div class="contenedor-texto-collage">
            <h1>Te quiero con todo mi ser</h1>
            <p>Te amo corazon.</p>
        </div>

        <div class="colage">
            <img src="1.jpg" class="img1">
            <img src="2.jpg" class="img2">
            <img src="3.jpg" class="img3">
            <img src="4.jpg" class="img4">
            <img src="5.jpg" class="img5">
            <img src="6.jpg" class="img6">
            <img src="7.jpg" class="img7">
            <img src="8.jpg" class="img8">
            <img src="1.jpg" class="c1">
            <img src="2.jpg" class="c2">
            <img src="3.jpg" class="c3">
            <img src="4.jpg" class="c4">
            <img src="5.jpg" class="c5">
            <img src="6.jpg" class="c6">
            <img src="7.jpg" class="c7">
            <img src="8.jpg" class="c8">
        </div>
    </div>

<script>
    const colors = ["#c70000", "#ea6363", "#FF6666", "#ffbbbb"];
    const baseHearts = [];
    const letterText = 
        'Para el amor de mi vida:\n\n' +
        'Si pudiera elegir un lugar\n' +
        'seguro, sería a tu lado.\n\n' +
        'Cuanto más tiempo estoy\n' +
        'contigo más te amo.\n\n' +
        '                -- I Love You!';

    let charIndex = 0;
    const speed = 50; 
    const inicio = new Date("2025-09-20T00:00:00");
    
    let heartsIntervalId = null;

    window.addEventListener("load", () => {
        const cursor = document.getElementById("fakeCursor");
        const heart = document.getElementById("mainHeart");
        const text = document.getElementById("mainText");
        const container = document.getElementById("mainContainer");
        const line = document.getElementById("bottomLine");
        const tree = document.getElementById("tree");
        const letterContainer = document.getElementById("letterContainer");
        const contador = document.getElementById("contador");

        const heartRect = heart.getBoundingClientRect();
        cursor.style.left = "0px";
        cursor.style.top = "0px";

        setTimeout(() => {
            cursor.style.left = heartRect.left + "px";
            cursor.style.top = heartRect.top + "px";
        }, 800);

        setTimeout(() => {
            text.classList.add("absorb");
            heart.classList.add("to-circle");
            
            setTimeout(() => {
                container.classList.add("move-down");
                line.classList.add("expand");

                setTimeout(() => {
                    tree.classList.add("grow");
                    letterContainer.style.opacity = "1";
                    contador.style.opacity = "1";
                    typeWriter(); 
                    actualizarContador();
                    setInterval(actualizarContador, 1000);

                    setTimeout(() => {
                        drawTreeFoliage(); 
                        heartsIntervalId = setInterval(floatHearts, 450);
                    }, 3200); 

                }, 1000);
            }, 800);
        }, 2200);
    });

    function typeWriter() {
        const textElement = document.getElementById("text");
        if (charIndex < letterText.length) {
            const char = letterText.charAt(charIndex);
            if (char === "\n") textElement.innerHTML += "<br>";
            else if (char === " ") textElement.innerHTML += "&nbsp;";
            else textElement.innerHTML += char;
            charIndex++;
            setTimeout(typeWriter, speed);
        } else {
            setTimeout(transicionEscena, 5000);
        }
    }

    function transicionEscena() {
        // Detener generación de nuevos pétalos
        if (heartsIntervalId !== null) {
            clearInterval(heartsIntervalId);
            heartsIntervalId = null;
        }

        // Eliminar TODOS los pétalos/corazones inmediatamente
        document.querySelectorAll('.petal').forEach(p => p.remove());
        
        // Limpiar también el array de posiciones base (por limpieza)
        baseHearts.length = 0;

        // Fade out de la escena principal
        document.getElementById("scene-1").classList.add("fade-out-element");
        document.getElementById("fakeCursor").classList.add("fade-out-element");

        // Fondo negro
        document.body.classList.add("bg-black");

        // Mostrar collage
        setTimeout(() => {
            document.getElementById("scene-1").style.display = "none";
            document.getElementById("collage-scene").style.display = "flex";
        }, 2000);
    }

    function actualizarContador() {
        const ahora = new Date();
        let diferencia = ahora - inicio;
        const dias = Math.floor(diferencia / (1000 * 60 * 60 * 24));
        diferencia -= dias * (1000 * 60 * 60 * 24);
        const horas = Math.floor(diferencia / (1000 * 60 * 60));
        diferencia -= horas * (1000 * 60 * 60);
        const minutos = Math.floor(diferencia / (1000 * 60));
        diferencia -= minutos * (1000 * 60);
        const segundos = Math.floor(diferencia / 1000);
        document.getElementById("dias").textContent = dias;
        document.getElementById("horas").textContent = horas;
        document.getElementById("minutos").textContent = minutos;
        document.getElementById("segundos").textContent = segundos;
    }

    function drawTreeFoliage() {
        const trunk = document.getElementById("trunk");
        const trunkRect = trunk.getBoundingClientRect();
        const centerX = trunkRect.left + trunkRect.width / 2;
        const centerY = trunkRect.top + 50; 
        const scale = 18; 
        const total = 250; 

        for (let t = 0; t < total; t++) {
            const angle = Math.random() * Math.PI * 2;
            const r = Math.random() * scale * (0.8 + Math.random()/2);
            const x = centerX + (16 * Math.pow(Math.sin(angle), 3)) * r;
            const y = centerY - (13 * Math.cos(angle) - 5 * Math.cos(2*angle) - 2 * Math.cos(3*angle) - Math.cos(4*angle)) * r;
            const color = colors[Math.floor(Math.random() * colors.length)];
            const petal = document.createElement('div');
            petal.className = 'petal fade-in';
            petal.style.left = `${x}px`;
            petal.style.top = `${y}px`;
            petal.style.background = color;
            petal.style.transform = `rotate(${-45 + Math.random() * 40 - 20}deg)`;
            petal.style.animationDelay = `${Math.random() * 1.5}s`;
            document.body.appendChild(petal);
            baseHearts.push({x, y, color});
        }
    }

    function floatHearts() {
        const num = Math.floor(Math.random() * 2) + 1;
        for (let i = 0; i < num; i++) {
            if (baseHearts.length === 0) return;
            const idx = Math.floor(Math.random() * baseHearts.length);
            const base = baseHearts[idx];
            const p = document.createElement('div');
            p.className = 'petal fade-in'; 
            p.style.left = `${base.x}px`;
            p.style.top = `${base.y}px`;
            p.style.background = base.color;
            p.style.animation = `fadeInPetal 0.5s ease forwards, floatLeft ${5 + Math.random()*3}s linear forwards`;
            document.body.appendChild(p);
            setTimeout(() => p.remove(), 7000);
        }
    }
</script>
</body>
</html>
