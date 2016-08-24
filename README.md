# elixir_serial

### *** Attention: Use [Nerves UART](https://github.com/nerves-project/nerves_uart) for new projects ***

This is a port program with elixir driver for serial communication.

The C code was originally written by Johan Bevemyr in 1996 and
sporadically maintained by Tony Garnock-Jones from 2007 onwards.

## Examples
### Opening a port
```elixir
{:ok, serial} = Serial.start_link

Serial.open(serial, "/dev/ttyS0")
Serial.set_speed(serial, 57600)
Serial.connect(serial)
```

### Sending data
```elixir
Serial.send_data(serial, <<0x01, 0x02, 0x03>>)
```

### Receiving data
```elixir
def handle_info({:elixir_serial, serial, data}, state) do
# do something with the data
end
```

## License

Copyright (c) 1996, 1999 Johan Bevemyr  
Copyright (c) 2007, 2009 Tony Garnock-Jones
Copyright (c) 2015 Bitgamma OÜ

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
