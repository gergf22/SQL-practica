-- PRÁCTICA ADICIONAL PROYECTO SPOTIFY
 -- (buscar la base de datos proyecto_spotify brindada por el profesor)

-- Realizar los siguientes informes: 
-- 1) Mostrar el nombre de usuario y contar la cantidad de playlist que tiene.

select nombreusuario,  count(idPlaylist) from usuario u
inner join playlist p on u.idUsuario = p.idusuario
group by nombreusuario;
-- 2) Generar un reporte, donde se muestre el método de pago , 
-- la cantidad de operaciones que se realizaron con cada uno y el importe total .

select tipoFormaPago, count(idPagos),sum(importe) from pagos p
join datospagoxusuario dpu on dpu.idDatosPagoxUsuario = p.IdDatosPagoxUsuario
join tipoformapago tp on tp.idTipoFormaPago = dpu.idTipoFormaPago
group by tipoFormaPago;

-- 3) Listar las canciones que tienen los artistas cuyo nombre contiene la letra “r” y el pertenecen al código de género 20. 

select c.titulo, ar.nombre , IdGenero  from cancion c
join album a on a.idAlbum = c.IdAlbum
join artista ar on ar.idartista = a.idArtista
join generoxcancion g on g.IdCancion = c.idCancion
where ar.nombre like "%r%" and idGenero = 20;

-- 4) Listar todos los usuarios que que pagaron con efectivo y la fecha de pago sea del 2020

select distinct nombreusuario, extract(year from p.fechaPago), tipoformapago from pagos p
join datospagoxusuario dp on dp.iddatospagoxUsuario = p.IdDatospagoxUsuario
join tipoformapago tp on tp.idtipoFormaPago = dp.idTipoFormaPago
join usuario u on u.idUsuario = dp.idusuario
where tipoformapago = "efectivo" and  extract(year from p.fechaPago) = "2020";

-- 5) Generar un reporte de todas las canciones, cuyo álbum no posee imagen de portada.

select c.titulo, imagenportada  from cancion c
join album a on c.IdAlbum = a.idAlbum
where imagenportada is null;


-- 6) Genera un reporte por género e informar la cantidad de canciones que posee. 
-- 	Si una canción tiene más de un género, debe ser incluida en la cuenta de cada uno de esos géneros.

select Genero, count(c.idCancion) from genero g
join generoxcancion gc on gc.IdGenero = g.idGenero
join cancion c on gc.IdCancion = c.idCancion
group by Genero;

-- 7) Listar todos las playlist que no están en estado activo y a que usuario pertenecen , ordenado por la fecha de eliminación.

	select titulo playlist, u.nyap Usuario, ep.descripcion estado, Fechaeliminada  from playlist p
    join usuario u on p.idusuario = u.idUsuario
    join estadoplaylist ep on ep.idEstadoPlaylist = p.idestado
    where ep.descripcion = "eliminada"
    order by Fechaeliminada;
    
    

-- 8) Generar un reporte que muestre por tipo de usuario, la cantidad de usuarios que posee.

select TipoUsuario, count(idUsuario) "cantidad usuarios"  from tipousuario tu
join usuario u on tu.idTipoUsuario = u.IdTipoUsuario
group by TipoUsuario;

-- 9) Listar la suma total obtenida por cada tipo de suscripción, en el periodo del 01-01-2020 al 31-12-2020.

select TipoUsuario suscripcion, sum(p.Importe) total from suscripcion s
join tipousuario tp on tp.idTipoUsuario = s.IdTipoUsuario
join pagos p on p.idpagos = s.idpagos
where p.fechaPago between "2020-01-01" and "2020-12-31"
group by TipoUsuario;

-- 10) Listar el álbum y la discográfica que posea la canción con más reproducciones.

select a.titulo album, d.nombre discográfica, c.titulo canción, c.cantreproduccion reproducciones  from album a
join discografica d on d.idDiscografica = a.iddiscografica
join cancion c on c.IdAlbum = a.idAlbum
order by cantreproduccion desc
limit 1;

-- 11) Listar todos los usuarios que no hayan generado una playlist 

select u.nyap Usuario, idplaylist playlist from usuario u
left join playlist p on p.idusuario = u.idUsuario 
where p.idPlaylist is null;

-- 12) Listar todas las canciones hayan o no recibido likes (cuántos) y aclarar si han sido reproducidas o no. 
-- Listar las 15 primeras ordenadas como si fueran un Ranking 

select titulo, cantlikes likes, 
case 
when cantreproduccion > 0 then "Ha sido reproducida"
else "no tiene reproducciones"
end "¿reproducida?"
from cancion
order by cantlikes desc
limit 15;


-- 13) Generar un reporte con el nombre del artista y el nombre de la canción que no pertenecen a ninguna lista. 

select art.Nombre artista, c.titulo canción from cancion c
join album a on a.idAlbum = c.idAlbum
join artista art on art.idArtista = a.idArtista
left join playlistxcancion p on p.idcancion = c.idCancion 
where p.idPlaylistxCancion is null;

-- 14) Listar todas las canciones, el nombre del artista, la razón social de la discográfica y  la cantidad de veces que fue reproducida. 

select c.titulo Canción, ar.Nombre Interprete, d.nombre "razon social", cantreproduccion Reproducciones from cancion c
join album al on al.idAlbum = c.idAlbum
join artista ar on ar.idArtista = al.idArtista
join discografica d on d.idDiscografica = al.iddiscografica;


-- 15) listar todas las discográficas, que pertenezcan a Inglaterra y la cantidad de álbumes que hayan editado. 

select d.nombre Discográfica, Pais, count(a.idAlbum) Albumes from discografica d
join album a on a.iddiscografica = d.idDiscografica
join pais p on p.idPais = d.idPais 
where p.Pais = "Inglaterra"
group by d.nombre;

-- 16) Listar a todos los artistas que no poseen ningún álbum. 

select * from artista ar
left join album al on ar.idArtista = al.idartista
where idAlbum is null;

-- 17) Listar todos los álbumes que tengan alguna canción que posea más de un género 

select al.titulo Album, c.titulo Canción, count(g.IdGenero) Géneros from album al 
join cancion c on c.IdAlbum = al.idAlbum
join generoxcancion g on c.idCancion = g.idcancion
group by c.titulo, al.titulo
having Géneros > 1;




-- 18) Generar un reporte por usuario , listando las suscripciones que tiene o tuvo, el importe que abonó y 
-- los datos de las formas de pago con que lo realizó.

select distinct u.nyap Usuario, tu.TipoUsuario suscripciones,p.Importe Pagado , tp.TipoFormaPago "Forma pago" from usuario u
join tipousuario tu on tu.idTipousuario = u.idtipoUsuario
join suscripcion s on s.idusuario = u.idUsuario
join pagos p on p.idPagos = s.idpagos
join datospagoxusuario dp on dp.idusuario = u.idUsuario
join tipoformapago tp on tp.idtipoFormaPago = dp.idTipoFormaPago
order by u.nyap;




