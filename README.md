# Yay Installer for SteamOS (v1.0.0)

## English

This is a bash script that automates the installation of "yay" on SteamOS, allowing you to easily manage AUR (Arch User Repository) packages. "yay" provides a user-friendly interface for searching, installing, and updating packages from the AUR.

### Disclaimer

This script is provided under the Creative Commons Attribution CC BY 4.0 license. You are free to modify, distribute, and use this script for your own purposes, including commercial use, as long as proper attribution is given to the original author. The script is provided as-is, without any warranty. Use it at your own risk.

### Usage

1. Open a terminal on your SteamOS system.
2. Navigate to the directory where this script is located.
3. Run the script with optional language parameter: `./yay_installer.sh [language]`.
   - Language: Optional parameter to specify the language for messages (en/es). Default: en.
   - Example: `./yay_installer.sh es` to run the script with Spanish messages.
4. Follow the prompts and provide any necessary input when prompted.
5. Once the installation is complete, you can use "yay" to manage AUR packages.

### Requirements

- sudo: Required for executing commands with root privileges.
- zenity: Optional, for displaying graphical dialogs. Falls back to text output if not available.
- pacman: Package manager for SteamOS.
- ping: Required for checking network connectivity.
- curl: Required for downloading resources.

**Note:** This script should be run on a SteamOS system.

### Important Note

- Ensure that you have an active internet connection before running this script.
- This script may require sudo/root privileges to execute certain commands.
- Make sure to review and verify the commands in this script before running it.

### License

This project is licensed under the Creative Commons Attribution CC BY 4.0 license. For more information, follow the link http://creativecommons.org/licenses/by/4.0/.

### Contributions

Contributions to this project are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request on GitHub.

## Author

- [Ximo](https://github.com/your-username)

---

**Disclaimer:** Use this script at your own risk. The author shall not be held liable for any issues or damages arising from the use of this script.

## Español

Este es un script en bash que automatiza la instalación de "yay" en SteamOS, permitiéndote gestionar fácilmente paquetes AUR (Arch User Repository). "yay" proporciona una interfaz fácil de usar para buscar, instalar y actualizar paquetes desde AUR.

### Descargo de responsabilidad

Este script se proporciona bajo la licencia Creative Commons Attribution CC BY 4.0. Eres libre de modificar, distribuir y utilizar este script para tus propios propósitos, incluyendo uso comercial, siempre y cuando se proporcione la atribución adecuada al autor original. El script se proporciona tal cual, sin ninguna garantía. Úsalo bajo tu propio riesgo.

### Uso

1. Abre una terminal en tu sistema SteamOS.
2. Navega hasta el directorio donde se encuentra este script.
3. Ejecuta el script con el parámetro opcional de idioma: `./yay_installer.sh [idioma]`.
   - Idioma: Parámetro opcional para especificar el idioma de los mensajes (en/es). Por defecto: en.
   - Ejemplo: `./yay_installer.sh es` para ejecutar el script con mensajes en español.
4. Sigue las instrucciones y proporciona cualquier entrada necesaria cuando se te solicite.
5. Una vez completada la instalación, puedes usar "yay" para gestionar paquetes AUR.

### Requisitos

- sudo: Requerido para ejecutar comandos con privilegios de administrador.
- zenity: Opcional, para mostrar diálogos gráficos. Si no está disponible, se utilizará salida de texto.
- pacman: Gestor de paquetes para SteamOS.
- ping: Requerido para comprobar la conectividad de red.
- curl: Requerido para descargar recursos.

**Nota:** Este script debe ejecutarse en un sistema SteamOS.

### Nota importante

- Asegúrate de tener una conexión a Internet activa antes de ejecutar este script.
- Es posible que este script requiera privilegios de administrador (sudo/root) para ejecutar ciertos comandos.
- Revisa y verifica los comandos en este script antes de ejecutarlo.

### Licencia

Este proyecto está licenciado bajo la licencia Creative Commons Attribution CC BY 4.0. Para obtener más información, consulta el enlace http://creativecommons.org/licenses/by/4.0/.

### Contribuciones

¡Las contribuciones a este proyecto son bienvenidas! Si tienes alguna sugerencia, informe de errores o solicitudes de funciones, por favor abre un issue o envía una solicitud de extracción en GitHub.

## Autor

- [Ximo](https://github.com/your-username)

---

**Descargo de responsabilidad:** Utiliza este script bajo tu propio riesgo. El autor no se hace responsable de cualquier problema o daño derivado del uso de este script.
