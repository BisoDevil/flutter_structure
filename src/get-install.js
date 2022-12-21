const vscode = require('vscode')
// const replace = require('replace-in-file')
const fs = require('fs')
const utils = require('./util.js')
var cp = require('child_process')

async function getxInstall() {
    
    var pubspecPath = await utils.getPubspecPath()

    if (typeof pubspecPath === 'string' && pubspecPath.length > 0) {

        /// path = .../
        let path = pubspecPath.replace("pubspec.yaml", "")
        vscode.workspace.fs.createDirectory(vscode.Uri.parse(`${path}assets`))        
        vscode.workspace.fs.createDirectory(vscode.Uri.parse(`${path}assets/images`))
        vscode.workspace.fs.createDirectory(vscode.Uri.parse(`${path}assets/launcher`))
        vscode.workspace.fs.createDirectory(vscode.Uri.parse(`${path}assets/icons`))
        vscode.workspace.fs.createDirectory(vscode.Uri.parse(`${path}assets/fonts`))
        
        var data = fs.readFileSync(pubspecPath, 'utf-8')
        var lines = data.split('\n')
        cp.exec(`cd ${path} && flutter pub add flutter_localizations --sdk=flutter`)
        cp.exec(`cd ${path} && flutter pub add --dev flutter_launcher_icons`)
        
        cp.exec(`
        cd ${path} &&
        flutter pub add get google_fonts flutter_svg font_awesome_flutter oktoast cached_network_image shared_preferences supercharged collection
        `, (err, stdout, stderr) => {
            if (err) {

                return console.log('error: ' + err)
            }
            data = fs.readFileSync(pubspecPath, 'utf-8')
            lines = data.split('\n')

            var index = 0
            for (let i = 0; i < lines.length; i++) {
                const element = lines[i];
                if (element.includes('uses-material-design')) {
                    index = i
                }
            }
            
            lines.splice(index,0,"    - assets/fonts/")
            lines.splice(index,0,"    - assets/icons/")
            lines.splice(index,0,"    - assets/images/")
            lines.splice(index,0,"    - assets/")
            lines.splice(index,0,"  assets:")

            // add launcher icons
            lines.push(`
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/launcher/launcher.png"
  remove_alpha_ios: true
  
  web:
    generate: true
    image_path: "assets/launcher/launcher.png"
  windows:
    generate: true
    image_path: "assets/launcher/launcher.png"
  macos:
    generate: true
    image_path: "assets/launcher/launcher.png"
            `)
            
            //

            lines.push("flutter_intl:")            
            lines.push("  enabled: true")

            lines = lines.filter((x)=>!x.startsWith('  #'))
            fs.writeFileSync(pubspecPath, lines.join('\n'), 'utf-8')
            
            
            cp.exec(`cd ${path} && flutter pub add intl`)    
            cp.exec(`cd ${path} && dart pub upgrade --major-versions`)    
            
        })
        
        

        // var projectName = lines[0].replace("name: ", "")
        await moveFile(path)
        vscode.window.showInformationMessage('Generate successful 🥳🤘🏻')
    }
    else { return }
}

/**
 * @param {string} path
 
 */
async function moveFile(path) {
    

    vscode.extensions.all.forEach((e) => {
        
        if (e.id.includes("basem-pattern")) {
            vscode.workspace.fs.copy(vscode.Uri.parse(`${e.extensionPath}/src/pattern/lib`), vscode.Uri.parse(`${path}lib`), { overwrite: true }).then(() => {

                // replace.sync({
                //     files: [
                //         `${path}lib/*.dart`,
                //         `${path}lib/app/data/api/*.dart`,
                //         `${path}lib/app/data/provider/*.dart`,
                //         `${path}lib/app/modules/home_module/*.dart`,
                //         `${path}lib/app/modules/splash_module/*.dart`,
                //         `${path}lib/app/routes/*.dart`,
                //         `${path}lib/app/themes/*.dart`,
                //         `${path}lib/app/translations/*.dart`,
                //         `${path}lib/app/utils/*.dart`,
                //         `${path}lib/app/utils/widgets/*.dart`,
                //         `${path}lib/app/utils/widgets/app_bar/*.dart`,
                //         `${path}lib/app/utils/widgets/app_button/*.dart`,
                //         `${path}lib/app/utils/widgets/app_divider/*.dart`,
                //         `${path}lib/app/utils/widgets/app_text_field/*.dart`,
                //         `${path}lib/app/utils/widgets/bottom_sheet_provider/*.dart`,
                //         `${path}lib/app/utils/widgets/dialog_provider/*.dart`,
                //         `${path}lib/app/utils/widgets/dialog_provider/view_dialog/*.dart`,
                //     ],
                //     from: /getx_generator/g,
                //     to: projectName,
                //     countMatches: true,
                // });
            })
        }
    })

}


module.exports = {
    getxInstall
}