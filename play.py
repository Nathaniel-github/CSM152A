import serial
import numpy as np
import sounddevice as sd

# Parameters
SERIAL_PORT = 'COM4'  # Replace with your UART COM port
BAUD_RATE = 115200    # Should match the Verilog UART baud rate (115200 is typical for simple UART communication)
SAMPLE_RATE = 48000   # Playback sample rate in Hz
BUFFER_SIZE = 1024    # Number of samples per audio buffer

# Open the serial connection
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)

def uart_audio_stream():
    # Generator that yields audio samples from UART, repeating the current sample until new data arrives.
    current_sample = np.zeros(BUFFER_SIZE, dtype=np.float32)  # Initialize current sample as zero buffer

    while True:
        if ser.in_waiting >= BUFFER_SIZE:  # Check if enough data is available
            data = ser.read(BUFFER_SIZE)  # Read the full buffer size
            audio_samples = np.frombuffer(data, dtype=np.uint8)
            audio_samples = ((audio_samples - 128) / 128.0).astype(np.float32)

            # Update the current sample immediately with new data
            current_sample[:] = audio_samples  # Replace the old sample with the new sample

        # Yield the current sample repeatedly
        yield current_sample

# Start audio playback
try:
    print("Playing audio in real-time. Press Ctrl+C to stop.")
    # Open a sounddevice stream
    with sd.OutputStream(
        samplerate=SAMPLE_RATE,
        channels=1,
        dtype='float32',
        blocksize=BUFFER_SIZE
    ) as stream:
        # Feed audio samples into the stream
        for audio_chunk in uart_audio_stream():
            stream.write(audio_chunk)

except Exception as e:
    print(f"Error: {e}")
finally:
    print("Exiting...")




""" 
# Plays well, but there is a delay when switching to another note.
import serial 
import numpy as np
import sounddevice as sd

# Parameters
SERIAL_PORT = 'COM4'  # Replace with your UART COM port
BAUD_RATE = 115200    # Should match the Verilog UART baud rate (115200 is typical for simple UART communication)
SAMPLE_RATE = 48000   # Playback sample rate in Hz
BUFFER_SIZE = 1024    # Number of samples per audio buffer

# Open the serial connection
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)

def uart_audio_stream():
    # Generator that yields audio samples from UART without pauses between tones.
    while True:
        if ser.in_waiting >= BUFFER_SIZE:
            data = ser.read(BUFFER_SIZE)
            audio_samples = np.frombuffer(data, dtype=np.uint8)
            audio_samples = ((audio_samples - 128) / 128.0).astype(np.float32)

            # Repeat the audio chunk to fill the buffer size if necessary
            # This makes sure each tone is played in continuous loops
            repeated_samples = np.tile(audio_samples, 5)

            # Yield the audio chunk directly without any additional delay
            yield repeated_samples

# Start audio playback
try:
    print("Playing audio in real-time. Press Ctrl+C to stop.")
    # Open a sounddevice stream
    with sd.OutputStream(
        samplerate=SAMPLE_RATE,
        channels=1,
        dtype='float32',
        blocksize=BUFFER_SIZE
    ) as stream:
        # Feed audio samples into the stream
        for audio_chunk in uart_audio_stream():
            stream.write(audio_chunk)

except Exception as e:
    print(f"Error: {e}")
finally:
    print("Exiting...") """




""" 
# Stops immediately when a new sample is received, but has a lot of pops.
import serial
import numpy as np
import sounddevice as sd

# Parameters
SERIAL_PORT = 'COM4'  # Replace with your UART COM port
BAUD_RATE = 115200    # Should match the Verilog UART baud rate (115200 is typical for simple UART communication)
SAMPLE_RATE = 48000   # Playback sample rate in Hz
BUFFER_SIZE = 1024    # Number of samples per audio buffer

# Open the serial connection
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)

def uart_audio_stream():
    # Generator that yields audio samples from UART, switching to new sample immediately.
    current_sample = np.zeros(BUFFER_SIZE, dtype=np.float32)  # Initialize current sample as zero buffer

    while True:
        if ser.in_waiting >= BUFFER_SIZE:  # Check if enough data is available
            data = ser.read(BUFFER_SIZE)  # Read the full buffer size
            audio_samples = np.frombuffer(data, dtype=np.uint8)
            audio_samples = ((audio_samples - 128) / 128.0).astype(np.float32)

            # Update the current sample immediately with new data
            current_sample[:] = audio_samples  # Replace the old sample with the new sample

            # Yield the new audio sample immediately (no repetition)
            yield current_sample

# Start audio playback
try:
    print("Playing audio in real-time. Press Ctrl+C to stop.")
    # Open a sounddevice stream
    with sd.OutputStream(
        samplerate=SAMPLE_RATE,
        channels=1,
        dtype='float32',
        blocksize=BUFFER_SIZE
    ) as stream:
        # Feed audio samples into the stream
        for audio_chunk in uart_audio_stream():
            stream.write(audio_chunk)

except Exception as e:
    print(f"Error: {e}")
finally:
    print("Exiting...") """




""" 
# Original script.
import serial
import numpy as np
import sounddevice as sd
import time

# Parameters
SERIAL_PORT = 'COM4'  # Replace with your UART COM port
BAUD_RATE = 115200    # Should match the Verilog UART baud rate (115200 is typical for simple UART communication)
SAMPLE_RATE = 48000   # Playback sample rate in Hz
BUFFER_SIZE = 1024    # Number of samples per audio buffer

# Open the serial connection
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)

def uart_audio_stream():
    # Generator that yields audio samples from UART, playing each chunk multiple times.
    fade_duration = 0.1  # Fade duration in seconds for each sample (both fade-in and fade-out)
    fade_samples = int(fade_duration * SAMPLE_RATE)  # Number of samples for fade-in/out
    fade_in_curve = np.linspace(0.0, 1.0, fade_samples)  # Fade-in curve
    fade_out_curve = np.linspace(1.0, 0.0, fade_samples)  # Fade-out curve

    repeat_count = 5  # Number of times to repeat each audio chunk
    
    try:
        while True:
            if ser.in_waiting >= BUFFER_SIZE:
                data = ser.read(BUFFER_SIZE)
                audio_samples = np.frombuffer(data, dtype=np.uint8)
                audio_samples = ((audio_samples - 128) / 128.0).astype(np.float32)

                # Apply fade-in for the first 'fade_samples' number of samples
                if len(audio_samples) >= fade_samples:
                    audio_samples[:fade_samples] *= fade_in_curve

                # Apply fade-out for the last 'fade_samples' number of samples
                if len(audio_samples) >= fade_samples:
                    audio_samples[-fade_samples:] *= fade_out_curve

                # Repeat the audio chunk `repeat_count` times
                repeated_samples = np.tile(audio_samples, repeat_count)

                # Yield the repeated audio samples
                yield repeated_samples

                time.sleep(1.0 / SAMPLE_RATE)  # Maintain sample rate timing
    except KeyboardInterrupt:
        print("Stopping audio playback...")
        return
    finally:
        ser.close()



# Start audio playback
try:
    print("Playing audio in real-time. Press Ctrl+C to stop.")
    # Open a sounddevice stream
    with sd.OutputStream(
        samplerate=SAMPLE_RATE,
        channels=1,
        dtype='float32',
        blocksize=BUFFER_SIZE
    ) as stream:
        # Feed audio samples into the stream
        for audio_chunk in uart_audio_stream():
            stream.write(audio_chunk)
except Exception as e:
    print(f"Error: {e}")
finally:
    print("Exiting...") """