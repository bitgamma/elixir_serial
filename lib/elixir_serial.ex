defmodule ElixirSerial do
  use GenServer

  @send 0
  @connect 1
  @disconnect 2
  @open 3
  @close 4
  @speed 5
  @parity_odd 6
  @parity_even 7
  @break 8

  def start_link(pid) do
    GenServer.start_link(__MODULE__, pid)
  end

  def open(pid, tty) do
    GenServer.call(pid, {:open, tty})
  end

  def close(pid) do
    GenServer.call(pid, {:cmd, @close})
  end

  def connect(pid) do
    GenServer.call(pid, {:cmd, @connect})
  end

  def disconnect(pid) do
    GenServer.call(pid, {:cmd, @disconnect})
  end

  def set_speed(pid, speed) do
    set_speed(pid, speed, speed)
  end

  def set_speed(pid, in_speed, out_speed) do
    GenServer.call(pid, {:speed, in_speed, out_speed})
  end

  def set_parity(pid, :odd) do
    GenServer.call(pid, {:cmd, @parity_odd})
  end
  def set_parity(pid, :even) do
    GenServer.call(pid, {:cmd, @parity_even})
  end

  def break(pid) do
    GenServer.call(pid, {:cmd, @break})
  end

  def send(pid, data) do
    GenServer.call(pid, {:send, data})
  end

  def init(pid) do
    exec = :code.priv_dir(:elixir_serial) ++ '/serial'
    port = Port.open({:spawn_executable, exec}, [{:args, ['-erlang']}, :binary, {:packet, 2}])
    {:ok, {pid, port}}
  end

  def handle_call({:open, tty}, _from, {_pid, port} = state) do
    Port.command(port, [@open, tty])
    {:reply, :ok, state}
  end
  def handle_call({:speed, new_in_speed, new_out_speed}, _from, {_pid, port} = state) do
    Port.command(port, [@speed, Integer.to_char_list(new_in_speed), ' ', Integer.to_char_list(new_out_speed), 0])
    {:reply, :ok, state}
  end
  def handle_call({:cmd, cmd}, _from, {_pid, port} = state) do
    Port.command(port, [cmd])
    {:reply, :ok, state}
  end
  def handle_call({:send, data}, _from, {_pid, port} = state) do
    Port.command(port, [@send, data])
    {:reply, :ok, state}
  end
end
