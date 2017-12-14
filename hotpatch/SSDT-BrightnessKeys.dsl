DefinitionBlock("", "SSDT", 2, "hack", "BrightnessKeys", 0)
{
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_Q10, 0, NotSerialized)  // _Qxx: EC Query
        {               
            // Brightness Down
            Notify (PS2K, 0x0205)
            Notify (PS2K, 0x0285)
        }

        Method (_Q11, 0, NotSerialized)  // _Qxx: EC Query
        {                
            // Brightness Up
            Notify (PS2K, 0x0206)
            Notify (PS2K, 0x0286)
        }
    }
}