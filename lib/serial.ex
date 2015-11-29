defmodule Serial do
  @moduledoc """
  Serial communication through Elixir ports.
  """

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
  @flow_control 9

  @doc """
  Starts a serial port. The process invoking this function will receive
  messages in the form of `{:elixir_serial, pid, data}`.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, self(), opts)
  end

  @doc """
  Opens a connection to the given tty.
  """
  def open(pid, tty) do
    GenServer.call(pid, {:open, tty})
  end

  @doc """
  Close the currently open connection.
  """
  def close(pid) do
    GenServer.call(pid, {:cmd, @close})
  end

  @doc """
  Reopens the connection to the current tty.
  """
  def connect(pid) do
    GenServer.call(pid, {:cmd, @connect})
  end

  @doc """
  Disconnects from the current tty.
  """
  def disconnect(pid) do
    GenServer.call(pid, {:cmd, @disconnect})
  end

  @doc """
  Sets the connection speed to the given value.
  """
  def set_speed(pid, speed) do
    set_speed(pid, speed, speed)
  end

  @doc """
  Sets the input and output connection speed to the given values.
  """
  def set_speed(pid, in_speed, out_speed) do
    GenServer.call(pid, {:speed, in_speed, out_speed})
  end

  @doc """
  Sets the parity to either `:odd` and `:even`.
  """
  def set_parity(pid, :odd) do
    GenServer.call(pid, {:cmd, @parity_odd})
  end
  def set_parity(pid, :even) do
    GenServer.call(pid, {:cmd, @parity_even})
  end

  @doc """
  Sends a break to the open connection.
  """
  def break(pid) do
    GenServer.call(pid, {:cmd, @break})
  end

  @doc """
  Enable or disable flow control.
  """
  def set_flow_control(pid, enable) do
    set_flow_control(pid, enable, enable)
  end

  @doc """
  Enable or disable flow control.
  """
  def set_flow_control(pid, in_enable, out_enable) do
    GenServer.call(pid, {:flow_control, in_enable, out_enable})
  end

  @doc """
  Sends data over the open connection.
  """
  def send_data(pid, data) do
    GenServer.call(pid, {:send, data})
  end

  def init(pid) do
    exec = :code.priv_dir(:serial) ++ '/serial'
    port = Port.open({:spawn_executable, exec}, [{:args, ['-erlang']}, :binary, {:packet, 2}, :exit_status])
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
  def handle_call({:flow_control, new_in_enable, new_out_enable}, _from, {_pid, port} = state) do
    in_enable_char = if new_in_enable, do: '1', else: '0'
    out_enable_char = if new_out_enable, do: '1', else: '0'
    Port.command(port, [@flow_control, in_enable_char, out_enable_char])
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

  def handle_info({port, {:data, data}}, {pid, port} = state) do
    send(pid, {:elixir_serial, self(), data})
    {:noreply, state}
  end
  def handle_info({port, {:exit_status, status}}, {_pid, port} = state) do
    exit({:port_exit, status})
  end
end
