Shadowsocks-NaCl
================

Shadowsocks-NaCl is a Native Client port of shadowsocks,
provides high performance crypto and network relay on
web browser which support Native Client.

**Note:** This port of shadowsocks is **for Web App developer ONLY**, **NOT** for the end user.


Build
-----
1. Download and install [Native Client SDK](https://developer.chrome.com/native-client/sdk/download).
2. Set environment variable `NACL_SDK_ROOT` to SDK path (e.g., `~/nacl_sdk/pepper_41`).
3. Checkout [naclports](https://code.google.com/p/naclports/wiki/HowTo_Checkout?tm=4).
4. Follow the instructions in `naclports/README.rst` to install naclports.
5. Build and install OpenSSL to Native Client SDK. (e.g., `$ NACL_ARCH=pnacl make openssl`)
6. Update libsodium in naclports form 0.4.5 to 1.0.2 since ChaCha20 had been add from 0.6.0.
   You may change the content of `naclports/src/ports/libsodium/pkg_info` to

    ```
    NAME=libsodium
    VERSION=1.0.2
    URL=https://github.com/jedisct1/libsodium/releases/download/1.0.2/libsodium-1.0.2.tar.gz
    LICENSE=ISC
    SHA1=7280455f78186a711e226e55dec74bcf0a5ad79d
    ```
7. Build and install libsodium to Native Client SDK. (e.g., `$ NACL_ARCH=pnacl make libsodium`)
8. Clone this repository and use `$ make` to build.


Usage
-----
You can put an `<embed>` tag into webpage to load Native Client module, like:

```html
<embed id="shadowsocks"
       width=0 height=0
       src="/pnacl/Release/shadowsocks.nmf"
       type="application/x-pnacl" />
```

Then you can use `postMessage()` API to connect with Native Client module.

Currently, shadowsocks-nacl accepts three types of command.

1. Command: `connect`. You can use it connect to a remote server.

    ```javascript

    document.querySelector("#shadowsocks").postMessage({
        cmd: "connect",
        arg: {
            server: "example.com",  // Value must be a string
            server_port: 8388,      // Value must be a number
            local_port: 1080,       // Value must be a number
            method: "aes-256-cfb",  // Value must be a string and in supported method list
            password: "password"    // Value must be a string
            timeout: 300            // Value in seconds and must be a number
        }
    });
   ```

2. Command: `disconnect`. You can use it to disconnect from a remote server.

    ```javascript
    document.querySelector("#shadowsocks").postMessage({
        cmd: "disconnect"
    });

    ```

3. Command: `sweep`. You should run this command repatedly in fixed time to sweep "deadly" connection.

    ```javascript
    setInterval(function() {
        document.querySelector("#shadowsocks").postMessage({
            cmd: "sweep"
        });
    }, 120 * 1000);
    ```


Test flight
----------
A Chromium App is provided to help testing and debugging.

You can open `chrome://extensions/`, check `Developer Mode`,
click `Load Unpacked Extension`, select the root directory of this project.

You will find a new App named `Shadowsocks NaCl Test flight` in `chrome://extensions/`,
click `Inspect views: index.html` will open a developer tools window and you can try
above-mentioned command here.


License
-------
![GPLv3](https://www.gnu.org/graphics/gplv3-127x51.png)

Shadowsocks-NaCl is licensed under [GNU General Public License](https://www.gnu.org/licenses/gpl.html) Version 3.

Shadowsocks-NaCl is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Shadowsocks-NaCl is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
