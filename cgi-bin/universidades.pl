#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Encode;  

my $q = CGI->new;

my $nombreBusqueda = $q->param('nombre') // '';      
my $licenciamientoBusqueda = $q->param('licenciamiento') // '';
my $departamentoBusqueda = $q->param('departamento') // '';     
my $programaBusqueda = $q->param('programa') // '';            
my $archivo = 'ProgramasdeUniversidades.csv';  

open my $miArchivo, '<:encoding(UTF-8)', $archivo or die "No se pudo abrir el archivo '$archivo': $!";

my @universidades;
my $header = <$miArchivo>; 

while (my $fila = <$miArchivo>) {
    chomp $fila;
    my @columnas = split /\|/, $fila;  # Separar las columnas con el delimitador '|'

    # Asignar cada columna a una variable correspondiente
    my ($codigo_entidad, $nombre, $tipo_gestion, $estado_licenciamiento,
        $periodo, $codigo_filial, $nombre_filial, $departamento_filial,
        $provincia_filial, $codigo_local, $departamento_local, $provincia_local,
        $distrito_local, $latitud, $longitud, $tipo_autorizacion_local,
        $denominacion_programa, $tipo_nivel_academico, $nivel_academico,
        $codigo_clase_programa_n2, $nombre_clase_programa_n2,
        $tipo_autorizacion_programa, $tipo_autorizacion_programa_local) = @columnas;

    # Realizar búsqueda combinada (ignorar campos vacíos)
    if (
        ($nombreBusqueda eq '' || $nombre =~ /\Q$nombreBusqueda\E/i) &&
        ($licenciamientoBusqueda eq '' || $periodo == $licenciamientoBusqueda) &&
        ($departamentoBusqueda eq '' || $departamento_local =~ /\Q$departamentoBusqueda\E/i) &&
        ($programaBusqueda eq '' || $denominacion_programa =~ /\Q$programaBusqueda\E/i)
    ) {
        $nombre =~ s/\Q$nombreBusqueda\E/<span class="highlight">$&<\/span>/gi if $nombreBusqueda;
        $departamento_local =~ s/\Q$departamentoBusqueda\E/<span class="highlight">$&<\/span>/gi if $departamentoBusqueda;
        $denominacion_programa =~ s/\Q$programaBusqueda\E/<span class="highlight">$&<\/span>/gi if $programaBusqueda;

        push @universidades, { nombre => $nombre, periodo => $periodo, 
                            departamento => $departamento_local, 
                            programa => $denominacion_programa };
    }
}

close $miArchivo;

print $q->header('text/html; charset=UTF-8');
print "<!DOCTYPE html>";
print "<html><head><meta charset='UTF-8'><title>Resultados</title><link rel='stylesheet' href='../css/style.css'></head><body>";

if (@universidades) {
    print "<div class='results'>";
    print "<h1>Resultados de la búsqueda</h1>";
    foreach my $uni (@universidades) {
        print "<div class='result-item'>";
        print "<h2>$uni->{nombre}</h2>";
        print "<p><strong>Período de Licenciamiento:</strong> $uni->{periodo}</p>";
        print "<p><strong>Departamento Local:</strong> " . ($uni->{departamento} || "No disponible") . "</p>";
        print "<p><strong>Programa:</strong> " . ($uni->{programa} || "No disponible") . "</p>";
        print "</div>";
    }
    print "</div>";
} else {
    print "<h1>No se encontraron resultados para la búsqueda</h1>";
}

print "</body></html>";
