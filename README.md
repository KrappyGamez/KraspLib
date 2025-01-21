# KraspLib

KraspLib is a software library for the development of games for ZX Spectrum using Boriel Basic. It provides functionality to display sprites, draw maps, collision detection and a few more things. It also comes with a map editor.

It is the result of the experience I acquired in the last few years developping for Spectrum as an amateur. After various approaches I decided to make a balanced library I could use for my future projects and by the way make it available to anyone interested. It would be nice a talented artist (unlike me) creates a masterpiece out of this.

KraspLib is meant to be used with the Boriel ZX Basic compiler. Also, some graphic assets are provided but you might as well create your own since I am not a goot pixel artist. Anyway, the included graphics are in SevenUP format but you may use any other tool to create your own, provided that you can export them to binary.

Since the library has no executables itself, and the map editor is actually a local webpage, you may use whichever OS you prefer as long as the third party software required supports it. However, in this documentation all indications will focus on Windows, just beacause it is what I am used to.. if you use LINUX or any other system you can probably find the equivalences yourself. Sorry anyway for the inconvenience.

Have in mind that this is currently a beta and it is subject to changes, bugs, bugfixes, improvements, etc. but of course, feedback is welcome. You may send your feedback to krappygamez (at) gmx.com
Please notice the source code is terribly dirty and with comments in Spanish. Maybe some day I will take some time to clean it up but as of now it is the way it is. At least I tried to make the interface and the examples as clean as I could


Features:

KraspLib is meant to work on 48k machines, but if you know what you are doing it is relatively easy to tweak it to take advantage of the 128k models (basically extra RAM by paging and AY music). The goal is to provide balanced funcionality that can fit most cases while using the least resources possible. It features:
- Up to 8 16x16 pixel sprites, with optional ink color
- Up to 8 dots (2x2 pixels) also with optional ink color
- Map system based on blocks which can hold up to 256 rooms
- Up to 256 tiles (16x16 tiles of 8x8 pixels) for the map, each with a default color attribute
- Collision detection between sprites and / or dots, as well as with map blocks
- Easy rendering: just define the sprites and dots and call a function to render all graphics
- Input management, providing kempston support and redefinable keys
- A few standard sound effects



SPANISH - ESPAÑOL:


KraspLib es una librería de software para el desarrollo de juegos para ZX Spectrum usando Boriel Basic. Proporciona funcionalidad para mostrar sprites, dibujar mapas, detección de colisiones y algunas cosas más. También viene con un editor de mapas.

Es el resultado de mi experiencia adquirida en los últimos años desarrollando para Spectrum como aficionado. Después de varios planteamientos, decidí hacer una librería equilibrada que pudiera usar para mis futuros proyectos y, de paso, ponerla a disposición de cualquiera. Estaría bien que alguien con talento artístico (no como yo) creara una obra maestra con esto.

KraspLib está diseñado para ser utilizado con el compilador Boriel ZX Basic. Además, se proporcionan algunos recursos gráficos, aunque seguramente querrás crear los tuyos propios, ya que no soy buen grafista. En cualquier caso, los gráficos incluidos están en formato SevenUP pero puedes usar cualquier otra herramienta para crear los tuyos propios, siempre que puedas exportarlos a binario.

Dado que la librería no tiene ejecutables en sí, y el editor de mapas es en realidad una página web local, puedes usar el sistema operativo que prefieras siempre que el software de terceros requerido sea compatible. Sin embargo, en esta documentación todas las indicaciones se centrarán en Windows, simplemente porque es a lo que estoy acostumbrado. si usas LINUX o cualquier otro sistema, probablemente puedas apañarte por tu cuenta.. pero siento las molestias..

Ten en cuenta que se trata de una versión beta y está sujeta a cambios, errores, correcciones de errores, mejoras, etc. pero por supuesto, los comentarios son bienvenidos. Puedes enviar tus comentarios a krappygamez (arroba) gmx.com Ten en cuenta que el código fuente es terriblemente sucio. Tal vez algún día me ponga a limpiarlo, pero por el momento es como es. Al menos traté de hacer la interfaz y los ejemplos lo más limpios posibles


Características:

KraspLib está diseñado para funcionar en máquinas de 48k, pero si sabes lo que estás haciendo, es relativamente fácil apañarlo para aprovechar los modelos de 128k (básicamente RAM adicional por paginación y música AY). El objetivo es proporcionar una funcionalidad equilibrada que pueda adaptarse a la mayoría de los casos utilizando la menor cantidad de recursos posibles. Cuenta con:
- Hasta 8 sprites de 16x16 píxeles, con color de tinta opcional
- Hasta 8 puntos (2x2 píxeles) también con color de tinta opcional
- Sistema de mapas basado en bloques que puede albergar hasta 256 pantallas
- Hasta 256 tiles (16x16 tiles de 8x8 píxeles) para el mapa, cada uno con su atributo de color predeterminado
- Detección de colisiones entre sprites y/o puntos, así como con bloques de mapa
- Renderizado fácil: define los sprites y los puntos y llama a una función para dibujar todo
- Gestión de la entrada, con soporte Kempston y teclas redefinibles
- Un puñado de efectos de sonido estándar

