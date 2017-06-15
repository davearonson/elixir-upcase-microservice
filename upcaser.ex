defmodule Upcaser do

  def start, do: loop

  def loop do
    receive do
      whatever -> process whatever
    end
    loop
  end

  def process({str, from}) when is_binary(str) and is_pid(from) do
    IO.puts "Upcasing '#{str}' received from #{inspect(from)}"
    send from, {:ok, str |> String.upcase}
  end

  def process(whatever) do
    # can't even ass-u-me that there's a pid in it somewhere,
    # let alone that it's the sender's
    IO.puts "Received #{inspect(whatever)}, dunno what to do with it, dropping it in the bit bucket...."
  end

  # called manually to send stuff to an upcaser
  def upcase(upcaser, str) do
    send upcaser, {str, self}
    if is_binary(str) do
      receive do
        {:ok, reply} -> reply
      end
    end
  end

end
