# Construcción y parametrización de contenedores

En esta actividad se practicará con las instrucciones y funcionalidades de Docker para poder construir y
ejecutar una aplicación web conectada a una base de datos en la máquina local de cada estudiante. El
estudiante deberá escoger un proyecto web que haga uso de una base de datos. El reto es modificar el
código y hacer que se ejecute en un contenedor con variables

Un ejemplo de proyecto a utilizar podría ser el siguiente https://github.com/seanaharrison/node-expressmongodb-example. Requiere modificar el código, por ejemplo, con la librería npm “dotenv”
https://github.com/motdotla/dotenv para poder usar variables en la conexión de la base de datos.

### Fichero Dockerfile

Para poder crear nuestros propios contenedores será necesario crear un fichero Dokerfile en el que
incluiremos todas las instrucciones necesarias para incluir el código de nuestra solución y poder ejecutar el
contenedor en cualquier ordenador. El fichero Dockerfile debe incluir las instrucciones con su comentario
asociado, de igual forma que en ejercicios anteriores.

El fichero Dockerfile debe incluir:
• Instrucciones WORKDIR, LABEL, ENV, COPY O ADD, RUN, EXPOSE…
• Debe incluir un ENTRYPOINT
### Subida de imagen a la herramienta Harbor.
Una vez hayamos configurado y generado nuestra imagen Docker, la subiremos a la herramienta Harbor en
la URL https://harbor.tallerdevops.com/ con las credenciales facilitadas en el tablero.
Esta herramienta os permitirá optimizar la imagen generada a nivel de vulnerabilidades y su tamaño.
### Fichero de despliegue
De igual forma que en el ejercicio anterior, se deberá crear un documento bash o de texto con el nombre
deploy.sh indicando las instrucciones que se han realizado, así como un comentario de cada instrucción que
indique el propósito de esta.

El fichero de instrucciones y la aplicación para ejecutar en local debe cumplir con los siguientes requisitos:
- Acceder a la solución una vez desplegada a través de http://localhost:8081
- Creación de las networks necesarias para proteger la base de datos.
- Persistencia de los datos de la base de datos en una carpeta “./database-data” que debe crearse en el mismo directorio desde donde se ejecuta el script o los comandos.
- Persistencia de datos en un volumen docker de la solución web (por ejemplo, si la solución permite la subida de ficheros, queremos que estos existan si volvemos a ejecutar la aplicación).
- Uso de variables de entorno y su explicación.
- La aplicación debe ejecutarse de tal forma que, si nuestra máquina se reinicia, siempre se inicie.

NOTA: En el requerimiento de persistir los datos de la solución web, tenéis que tener en cuenta que en el
arranque inicial, en la carpeta que se quieren persistir los datos no existirá ningún archivo y será necesario
modificar el fichero entrypoint para contemplar ese caso.
### Fichero de limpieza
Creación de un documento bash o txt con el nombre clean.sh con las instrucciones necesarias para eliminar
todo el contenido creado por el fichero de despliegue