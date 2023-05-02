Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public class Mouse {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SetCursorPos(int x, int y);

    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    public struct POINT {
        public int X;
        public int Y;
    }
}
'@

while ($true) {
    $point = New-Object Mouse+POINT
    [Mouse]::GetCursorPos([ref]$point)

    # Move the cursor by 1 pixel
    [Mouse]::SetCursorPos($point.X + 1, $point.Y + 1)

    # Wait for 1 minute
    Start-Sleep -Seconds 60

    # Move the cursor back to its original position
    [Mouse]::SetCursorPos($point.X, $point.Y)

    # Wait for 1 minute
    Start-Sleep -Seconds 60
}
