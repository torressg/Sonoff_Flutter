# On/Off - Interruptor Digital

## Descrição do Projeto

Um aplicativo Flutter para controlar interruptores Sonoff através de uma API personalizada em Node.js. 
Este projeto foi criado para evitar a necessidade de trocar o firmware dos dispositivos IoT Sonoff, oferecendo uma maneira direta e eficaz de controlá-los diretamente do seu smartphone.
[Artigo sobre o Desenvolvimento](https://medium.com/@guilhermevanderlei0210/on-off-interruptor-digital-21c42d712aee)

---

## 🚀 Começando

### Pré-requisitos

- Node.js
- Flutter SDK
- Um dispositivo Sonoff configurado e funcionando no App eWeLink
- Conhecimento básico em Dart, Flutter e Node.js

---

## 📦 Instalação

Clone o repositório e instale as dependências em ambas as pastas: `/on_off` e `/API`.

git clone 
cd Sonoff_Flutter/on_off
flutter pub get

cd Sonoff_Flutter/API
npm install

---

## 🎮 Uso

Inicie o servidor Node.js e depois execute o aplicativo Flutter.

cd API
node server.js

### Em um novo terminal
cd flutter_app
flutter run
OU
Utilize as extensões para dar Run no main.dart

---
