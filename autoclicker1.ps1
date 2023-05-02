Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseSimulator {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    [StructLayout(LayoutKind.Sequential)]
    public struct INPUT {
        public uint type;
        public MOUSEKEYBDHARDWAREINPUT Data;
    }

    [StructLayout(LayoutKind.Explicit)]
    public struct MOUSEKEYBDHARDWAREINPUT {
        [FieldOffset(0)]
        public MOUSEINPUT mi;

        [FieldOffset(0)]
        public KEYBDINPUT ki;

        [FieldOffset(0)]
        public HARDWAREINPUT hi;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MOUSEINPUT {
        public int dx;
        public int dy;
        public uint mouseData;
        public uint dwFlags;
        public uint time;
        public IntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct KEYBDINPUT {
        public ushort wVk;
        public ushort wScan;
        public uint dwFlags;
        public uint time;
        public IntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct HARDWAREINPUT {
        public uint uMsg;
        public ushort wParamL;
        public ushort wParamH;
    }

    public const uint INPUT_MOUSE = 0;
    public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const uint MOUSEEVENTF_LEFTUP = 0x0004;
}
"@;

function Click-Mouse {
    $inputDown = New-Object MouseSimulator+INPUT
    $inputDown.type = [MouseSimulator]::INPUT_MOUSE
    $inputDown.Data.mi.dwFlags = [MouseSimulator]::MOUSEEVENTF_LEFTDOWN
    [MouseSimulator]::SendInput(1, [MouseSimulator+INPUT[]]@($inputDown), [System.Runtime.InteropServices.Marshal]::SizeOf($inputDown))

    Start-Sleep -Milliseconds 10

    $inputUp = New-Object MouseSimulator+INPUT
    $inputUp.type = [MouseSimulator]::INPUT_MOUSE
    $inputUp.Data.mi.dwFlags = [MouseSimulator]::MOUSEEVENTF_LEFTUP
    [MouseSimulator]::SendInput(1, [MouseSimulator+INPUT[]]@($inputUp), [System.Runtime.InteropServices.Marshal]::SizeOf($inputUp))
}

while ($true) {
    Click-Mouse
    Start-Sleep -Seconds 5
}
