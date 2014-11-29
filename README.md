# Bloque2: Website observers shuttle.


[![Code Climate](https://codeclimate.com/github/the-cocktail/bloque2/badges/gpa.svg)](https://codeclimate.com/github/the-cocktail/bloque2)
[![Build Status](https://travis-ci.org/the-cocktail/bloque2.svg?branch=master)](https://travis-ci.org/the-cocktail/bloque2)

## Sobre la Estación M.I.R.
**Como si de una diosa se tratase**, conocedora de todo lo útil que ha aparecido en Internet desde la última vez que se acostó, así como la forma más adecuada de adaptarlo a la misma para que esta continúe mejorando la comunicación entre los seres humanos, **La Estación M.I.R. sabe en todo momento evaluar la presencia de cualquier sitio existente en La Red**.

![Foto de la MIR](app/assets/images/mir_500px.jpg)

## Sobre el verdadero Bloque DOS

La Estación inicialmente constaba de la base del Bloque DOS, que estaría equipada con cuatro puertos de atraque, dos en cada extremo, y dos puertos adicionales en una esfera de acoplamiento en la parte frontal de la estación. Finalmente, en agosto de 1978, evolucionó a un puerto en la parte de popa y cinco puertos en proa, en forma de esfera (nodo).

Fuente: Axisvega (http://axisvega.wordpress.com/mir/)

### Sobre nuestro Bloque2

Estaría compuesto por tres ejecutables:

* Uno de lanzamiento de _Spacecrafts_ desde _el Bloque2_ (**launch_spacecrafts.rb**) con _una misión_ asignada.
* Otro que ordena el comienzo de _la misión_ asignada a una _Spacecraft_ (**evaluate_website.rb**).
* Y otro para ver un resumen de los resultados obtenidos por las distintas _Spacecrafts_ (**show_reports.rb**)

Este podría ser el código de ejemplo de lo que sería lanzar una nave (que asumiría una misión por defecto de las disponibles en **config/missions**), después ordenar a un equipo humano que comience la misión asignada a dicha nave, y finalmente atracarla de vuelta en el _Bloque2_ junto a la puntuación obtenida tras realizar su _misión_:
<pre>
# Instanciamos una lanzadera:
mir_station = Launcher.new
# Lanzamos una nave:
spacecraft = mir_station.launch_spacecraft!
# Mandamos a un equipo que realice su misión:
report = HumanTeam.new(spacecraft).evaluate_website!
# Cuando el equipo termina su misión la reporta:
mir_station.just_landed! spacecraft, report[:score]
</pre>

Podría ser algo así. La motivación detrás de esta ceremonia es que la suite pueda correr en segundo plano y que las exploraciones de cada sitio web sean independientes, podiendo realizarlas eventualmente en paralelo y con RabbitMQ en mente para la implementación inicial.


## License

Bloque2 is released under the [MIT License](http://www.opensource.org/licenses/MIT).
