// Lenovo ThinkPad T450 Ultrabook | Hackintosh Build (macOS Mojave)
//
// Clover UEFI Hotpatch | SSDT-PNLF...
//
// Injects the proper configuration for the display and allows brightness control | Intel HD Graphics 5500 | 0x0AD9 Backlight For Framebuffer...
//
//
DefinitionBlock ("", "SSDT", 2, "LENOVO", "TP-PNLF", 0x00000000)
{
    External (_SB_.PCI0.IGPU, DeviceObj)
    External (RMCF.BKLT, IntObj)
    External (RMCF.FBTP, IntObj)
    External (RMCF.GRAN, IntObj)
    External (RMCF.LEVW, IntObj)
    External (RMCF.LMAX, IntObj)

    Scope (_SB.PCI0.IGPU)
    {
        OperationRegion (RMP3, PCI_Config, Zero, 0x14)
    }

    Device (_SB.PCI0.IGPU.PNLF)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
        Name (_CID, "backlight")  // _CID: Compatible ID
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_STA, 0x0B)  // _STA: Status
        Field (^RMP3, AnyAcc, NoLock, Preserve)
        {
            Offset (0x02), 
            GDID,   16, 
            Offset (0x10), 
            BAR1,   32
        }

        OperationRegion (RMB1, SystemMemory, (BAR1 & 0xFFFFFFFFFFFFFFF0), 0x000E1184)
        Field (RMB1, AnyAcc, Lock, Preserve)
        {
            Offset (0x48250), 
            LEV2,   32, 
            LEVL,   32, 
            Offset (0x70040), 
            P0BL,   32, 
            Offset (0xC2000), 
            GRAN,   32, 
            Offset (0xC8250), 
            LEVW,   32, 
            LEVX,   32, 
            Offset (0xE1180), 
            PCHL,   32
        }

        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            Local4 = One
            If (CondRefOf (\RMCF.BKLT))
            {
                Local4 = \RMCF.BKLT /* External reference */
            }

            If ((Zero == (One & Local4)))
            {
                Return (Zero)
            }

            Local0 = ^GDID /* \_SB_.PCI0.IGPU.PNLF.GDID */
            Local2 = Ones
            If (CondRefOf (\RMCF.LMAX))
            {
                Local2 = \RMCF.LMAX /* External reference */
            }

            Local3 = Zero
            If (CondRefOf (\RMCF.FBTP))
            {
                Local3 = \RMCF.FBTP /* External reference */
            }

            If ((Zero == Local3))
            {
                If ((Ones != Match (Package (0x10)
                                {
                                    0x010B, 
                                    0x0102, 
                                    0x0106, 
                                    0x1106, 
                                    0x1601, 
                                    0x0116, 
                                    0x0126, 
                                    0x0112, 
                                    0x0122, 
                                    0x0152, 
                                    0x0156, 
                                    0x0162, 
                                    0x0166, 
                                    0x016A, 
                                    0x46, 
                                    0x42
                                }, MEQ, Local0, MTR, Zero, Zero)))
                {
                    Local3 = One
                }
                Else
                {
                    Local3 = 0x02
                }
            }

            If ((One == Local3))
            {
                If ((Ones == Local2))
                {
                    Local2 = 0x0710
                }

                Local1 = (^LEVX >> 0x10)
                If (!Local1)
                {
                    Local1 = Local2
                }

                If ((Local2 != Local1))
                {
                    Local0 = ((^LEVL * Local2) / Local1)
                    Local3 = (Local2 << 0x10)
                    If ((Local2 > Local1))
                    {
                        ^LEVX = Local3
                        ^LEVL = Local0
                    }
                    Else
                    {
                        ^LEVL = Local0
                        ^LEVX = Local3
                    }
                }
            }
            ElseIf ((0x02 == Local3))
            {
                If ((Ones == Local2))
                {
                    If ((Ones != Match (Package (0x16)
                                    {
                                        0x0D26, 
                                        0x0A26, 
                                        0x0D22, 
                                        0x0412, 
                                        0x0416, 
                                        0x0A16, 
                                        0x0A1E, 
                                        0x0A1E, 
                                        0x0A2E, 
                                        0x041E, 
                                        0x041A, 
                                        0x0BD1, 
                                        0x0BD2, 
                                        0x0BD3, 
                                        0x1606, 
                                        0x160E, 
                                        0x1616, 
                                        0x161E, 
                                        0x1626, 
                                        0x1622, 
                                        0x1612, 
                                        0x162B
                                    }, MEQ, Local0, MTR, Zero, Zero)))
                    {
                        Local2 = 0x0AD9
                    }
                    ElseIf ((Ones != Match (Package (0x04)
                                    {
                                        0x3E9B, 
                                        0x3EA5, 
                                        0x3E92, 
                                        0x3E91
                                    }, MEQ, Local0, MTR, Zero, Zero)))
                    {
                        Local2 = 0xFFFF
                    }
                    Else
                    {
                        Local2 = 0x056C
                    }
                }

                If ((Zero == (0x02 & Local4)))
                {
                    Local5 = 0xC0000000
                    If (CondRefOf (\RMCF.LEVW))
                    {
                        If ((Ones != \RMCF.LEVW))
                        {
                            Local5 = \RMCF.LEVW /* External reference */
                        }
                    }

                    ^LEVW = Local5
                }

                If ((0x04 & Local4))
                {
                    If (CondRefOf (\RMCF.GRAN))
                    {
                        ^GRAN = \RMCF.GRAN /* External reference */
                    }
                    Else
                    {
                        ^GRAN = Zero
                    }
                }

                Local1 = (^LEVX >> 0x10)
                If (!Local1)
                {
                    Local1 = Local2
                }

                If ((Local2 != Local1))
                {
                    Local0 = ((((^LEVX & 0xFFFF) * Local2) / Local1) | 
                        (Local2 << 0x10))
                    ^LEVX = Local0
                }
            }

            If ((Local2 == 0x0710))
            {
                _UID = 0x0E
            }
            ElseIf ((Local2 == 0x0AD9))
            {
                _UID = 0x0F
            }
            ElseIf ((Local2 == 0x056C))
            {
                _UID = 0x10
            }
            ElseIf ((Local2 == 0x07A1))
            {
                _UID = 0x11
            }
            ElseIf ((Local2 == 0x1499))
            {
                _UID = 0x12
            }
            ElseIf ((Local2 == 0xFFFF))
            {
                _UID = 0x13
            }
            Else
            {
                _UID = 0x63
            }
        }
    }
}

