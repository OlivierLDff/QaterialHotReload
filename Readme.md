![qaterial-hotreload-black](https://user-images.githubusercontent.com/17255804/99963772-91d40b00-2d92-11eb-9938-c0ee31a21864.png)

|   Configuration   |                            Status                            |
| :---------------: | :----------------------------------------------------------: |
| Windows Installer | [![👷 Windows CI](https://github.com/OlivierLDff/QaterialHotReload/workflows/%F0%9F%91%B7%20Windows%20CI/badge.svg)](https://github.com/OlivierLDff/QaterialHotReload/actions?query=workflow%3A%22%F0%9F%91%B7+Windows+CI%22) |
|  Linux AppImage   | [![👷 AppImage CI](https://github.com/OlivierLDff/QaterialHotReload/workflows/%F0%9F%91%B7%20AppImage%20CI/badge.svg)](https://github.com/OlivierLDff/QaterialHotReload/actions?query=workflow%3A%22%F0%9F%91%B7+AppImage+CI%22) |
|     MacOs Dmg     | [![👷 MacOs CI](https://github.com/OlivierLDff/QaterialHotReload/workflows/%F0%9F%91%B7%20MacOs%20CI/badge.svg)](https://github.com/OlivierLDff/QaterialHotReload/actions?query=workflow%3A%22%F0%9F%91%B7+MacOs+CI%22) |

QaterialHotReload is an app that load a `.qml` file, and reloads it each time the file is saved on the system.

## Preview

**Open file**

![openfile](https://user-images.githubusercontent.com/17255804/99967065-9bac3d00-2d97-11eb-9bed-94fc94fbe973.gif)

**Open Folder**

![openfolder](https://user-images.githubusercontent.com/17255804/99967068-9c44d380-2d97-11eb-851f-e5cb7bd50576.gif)

**Typography Menu**

![typo2](https://user-images.githubusercontent.com/17255804/99967069-9cdd6a00-2d97-11eb-93e1-37b6b9f009bc.gif)

**Icon Menu**

![hoticon](https://user-images.githubusercontent.com/17255804/99967071-9cdd6a00-2d97-11eb-9e0a-9361daed4268.gif)

**Color Menu**

![hotcolor](https://user-images.githubusercontent.com/17255804/99967073-9d760080-2d97-11eb-90a8-cd2b8154fc7d.gif)

**Theme Button**

![themehot](https://user-images.githubusercontent.com/17255804/99967074-9e0e9700-2d97-11eb-96b9-61f90a9bdddb.gif)

**Import Path**

![importpath](https://user-images.githubusercontent.com/17255804/99968069-f2664680-2d98-11eb-91c8-96d79bc62f00.gif)

## Build & Execute

```bash
git clone https://github.com/OlivierLDff/QaterialHotReload
cd QaterialHotReload && mkdir build && cd build
cmake ..
cmake --build .
./QaterialHotReloadApp
```

Make sure Qt5 can be found by `find_package`.
- Either pass `-DCMAKE_PREFIX_PATH=/path/to/Qt/5.15.1/<binary>`. `<binary>` can be `msvc2019_64`, `gcc_64`, `clang_64`, ...
- Or set environment variable `Qt5_DIR`.

## Dependencies

![dependencies](./docs/dependencies.svg)

## Author

Olivier Le Doeuff, [olivier.ldff@gmail.com](olivier.ldff@gmail.com)

## License

**QaterialHotReload** is available under the MIT license. See the [License](./License) file for more info.