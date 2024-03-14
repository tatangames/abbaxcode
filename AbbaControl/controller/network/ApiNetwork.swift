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
let apiVersionApp = "ios 1.0.0"


let baseUrl:String = "http://192.168.1.29:8080/api/"
let baseUrlImagen: String = "http://192.168.1.29:8080/storage/archivos/"

// solicitar listado de iglesias
let apiListadoIglesias = baseUrl+"app/solicitar/listado/iglesias"
// registrar usuario
let apiRegistroUsuario = baseUrl+"app/registro/usuario"
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
