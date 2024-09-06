//
//  ApiNetwork.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 10/3/24.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift


//clave onesignal  cd253220-f1b1-4b46-9307-37cf176768a9

// utilizado al registrarse

//  04-08-2024
let apiVersionApp = "ios 1.1.4"


//let baseUrl:String = "http://192.168.1.29:8080/api/"
//let baseUrlImagen: String = "http://192.168.1.29:8080/storage/archivos/"

let baseUrl:String = "http://143.198.154.209/api/"
let baseUrlImagen: String = "http://143.198.154.209/storage/archivos/"



// solicitar listado de iglesias
let apiListadoIglesias = baseUrl+"app/solicitar/listado/iglesias"
// registrar usuario
let apiRegistroUsuario = baseUrl+"app/registro/usuario/v2"
// iniciar sesion
let apiIniciarSesion = baseUrl+"app/login"
// solicitar codigo para recuperacion de contraseña
let apiSolicitarCodigoPass = baseUrl+"app/solicitar/codigo/contrasena"
// verificar codigo y correo coinciden
let apiVerificarCodigoCorreo = baseUrl+"app/verificar/codigo/recuperacion"
// actualizar nueva contrasena se envia token
let apiActualizarPasswordReseteo = baseUrl+"app/actualizar/nueva/contrasena/reseteo"
// solicitar perfil en pantalla ajustes
let apiInformacionAjustes = baseUrl+"app/solicitar/listado/opcion/perfil"
// actualizar contrasena normal
let apiActualizarContrasena = baseUrl+"app/actualizar/contrasena"
// informacion perfil
let apiInfoMiPerfil = baseUrl+"app/solicitar/informacion/perfil"
// actualizar datos perfil
let apiActualizarPerfil = baseUrl+"app/actualizar/perfil/usuario"
// listado de notificaciones usuario
let apiListadoNotificaciones = baseUrl+"app/notificaciones/listado"
// listado insignias por ganar
let apiListadoInsigniaPorGanar = baseUrl+"app/listado/insignias/faltantes"
// listado de planes para ocultar
let apiListadoPlanesOcultar = baseUrl+"app/comunidad/planes/usuarios"
// actualizar planes ocultos
let apiActualizarPlanesOcultos = baseUrl+"app/comunidad/actualizarplanes/ocultosiphone"
// listado de biblias
let apiListadoBiblias = baseUrl+"app/listado/biblias"
// listado de caitulos de una biblia
let apiListadoBibliaCapitulos = baseUrl+"app/listado/biblia/capitulos"

// texto html de la biblia
// MODIFICADO: 18/06/2024
let apiBibliaHtml = baseUrl+"app/listado/bibliacapitulo/textos"
// listado de devocionales mis planes
let apiListadoDevoMisPlanes = baseUrl+"app/plan/listado/misplanes"
// listado de devocionales nuevos
let apiListadoDevoNuevos = baseUrl+"app/buscar/planes/nuevos"
// listado de devocionales completados
let apiListadoDevoCompletados = baseUrl+"app/plan/misplanes/completados"
// informacion de un devocional
let apiInformacionDevocional = baseUrl+"app/plan/seleccionado/informacion"
// listado de amistades ya aceptadas
let apiComunidadAceptado = baseUrl+"app/comunidad/listado/solicitud/aceptadas"
// iniciar plan amigos
let apiIniciarPlanAmigos = baseUrl+"app/comunidadplan/iniciar/plan/amigosiphone"
// iniciar plan solo
let apiIniciarPlanSolo = baseUrl+"app/plan/nuevo/seleccionar"
// informacion bloque fecha plan
let apiInformacionPlanBloque = baseUrl+"app/plan/misplanes/informacion/bloque"
// texto devocional
let apiInfoCuestionarioBloque = baseUrl+"app/plan/misplanes/cuestionario/bloque"
// informacion listado de preguntas
let apiInformacionPreguntasBloqueDeta = baseUrl+"app/plan/misplanes/preguntas/bloque"
// actualizar preguntas todas
let apiActualizarPreguntas = baseUrl+"app/plan/misplanes/preguntas/usuario/actualizariphone"


// informacion de textos devo cuando se hace click a un titulo
let apiInformacionTextoDevoCapitulo = baseUrl+"app/listado/biblia/devocionales"
// informacion listado preguntas para compartir, solo texto
let apiInfoPreguntasTextoCompartir = baseUrl+"app/plan/misplanes/preguntas/infocompartir"
// actualizar check de bloque detalle fecha
let apiActualizarCheckBloqueFecha = baseUrl+"app/plan/misplanes/actualizar/check"
// listado solicitudes de comunidad aceptadas
let apiComunidadListadoAceptados = baseUrl+"app/comunidad/listado/solicitud/aceptadas"
// enviar solicitud a otro usuario para ver su info
let apiEnviarSolicitudComunidad = baseUrl+"app/comunidad/enviar/solicitud"
// listado solicitudes pendientes comunidad enviadas
let apiListadoSoliPendienteEnviada = baseUrl+"app/comunidad/listado/solicitud/pendientes/enviadas"
// elimina solicitud ya sea aceptada o pendiente
let apiBorrarSolicitudPendiente = baseUrl+"app/comunidad/solicitud/eliminar"
// listado solicitudes pendiente comunidad Recibidas
let apiListadoSolicitudPendienteRecibida = baseUrl+"app/comunidad/listado/solicitud/pendientes/recibidas"
// aceptar solicitud que he recibido
let apiAceptarSolicitudRecibida = baseUrl+"app/comunidad/aceptarsolicitud/recibido"
// listado de informacion de bloque inicio
let apiListadoInfoInicio = baseUrl+"app/inicio/bloque/completa"
// compartir aplicacion
let apiCompartirAplicacion = baseUrl+"app/compartir/aplicacion"
// informacion de una insignia
let apiInfoInsignia = baseUrl+"app/insignia/individual/informacion"
// listado todos los videos
let apiListadoVideos = baseUrl+"app/inicio/todos/losvideos"
// listado de todas las imagenes
let apiListadoImagenes = baseUrl+"app/inicio/todos/lasimagenes"



let apiListaNivelesInsignia = baseUrl+"app/insignia/niveles/informacion"
let apiListadoPlanesItemsPreguntasComunidad = baseUrl+"app/comunidad/informacion/planes/itemspreguntas"

// listado de planes que yo agregue a comunidad
let apiListadoPlanesComunidadYoAdd = baseUrl+"app/comunidad/yoagregue/planeslistado"
// listado de como van mis amigos, como llevan contestado el plan
let apiListadoPlanesComunidaYoAddComoVan = baseUrl+"app/comunidad/yoagregue/planeslistado/informacion"
// listado de planes que me han agregado
let apiListadoMeHanAgregadoPlanes = baseUrl+"app/comunidad/mehanagregado/planes/listado"



// para bloque preguntas al compartir devocional para que sume contador
let apiCompartirDevoBloquePreguntas = baseUrl+"app/compartir/devocional"


// borrar notificaciones
let apiBorrarNotificaciones = baseUrl+"app/notificacion/borrarlistado"





//** INVITADO
let apiListadoBibliasInvitado = baseUrl+"app/listado/biblias/invitado"
let apiListadoBibliaCapitulosInvitado = baseUrl+"app/listado/biblia/capitulos/invitado"
let apiListadoVersiculosInvitado = baseUrl+"app/listado/biblia/versiculos/invitado"
let apiBibliaHtmlInvitado = baseUrl+"app/listado/versiculos/textos/invitado"


let apiListaPlanesAmigos = baseUrl+"app/comunidad/informacion/planes"
let apiComunidadInfoPlanItem = baseUrl+"app/comunidad/informacion/planes/items"
let apiInsigniasAmigos = baseUrl+"app/comunidad/informacion/insignias"
// listado de amigos que me tienen agregado a un plan
let apiListadoAmigosMeAgregaronSuPlan = baseUrl+"app/comunidad/mehanagregado/planes/amigos"

