DefinitionBlock("", "SSDT", 2, "hack", "batt", 0)
{
    External(_SB.PCI0.ACEL, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.ECOK, IntObj)
    External(_SB.PCI0.LPCB.EC.SW2S, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.MBNH, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BVLB, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BVHB, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BACR, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.MBST, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.MUT1, MutexObj)
    External(_SB.PCI0.LPCB.EC.MBTS, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BTVD, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.MBDC, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.SMRD, MethodObj)
    External(_SB.PCI0.LPCB.EC.BDVO, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.ACCC, FieldUnitObj)
    External(_SB.BAT0, DeviceObj)
    External(_SB.BAT0._STA, MethodObj)
    External(_SB.WMID, DeviceObj)
    External(PBIF, PkgObj)
    External(FABL, IntObj)
    External(PBST, PkgObj)
    External(SMA4, FieldUnitObj)
    External(UPUM, MethodObj)
    External(ITOS, MethodObj)
    External(GBFE, MethodObj)
    External(PBFE, MethodObj)
    External(MUT0, MutexObj)
    External(SMB0, FieldUnitObj)
    External(SMW0, FieldUnitObj)
    External(SMST, FieldUnitObj)
    External(SMCM, FieldUnitObj)
    External(SMAD, FieldUnitObj)
    External(SMPR, FieldUnitObj)
    
    Scope (_SB.PCI0.LPCB.EC)
    {
        OperationRegion (ERM2, EmbeddedControl, Zero, 0xFF)
        Field (ERM2, ByteAcc, Lock, Preserve)
        {
            Offset (0x70), 
            ADC0,8,ADC1,8, 
            FCC0,8,FCC1,8, 
            Offset (0x83),
            CUR0,8,CUR1,8, 
            BRM0,8,BRM1,8, 
            BCV0,8,BCV1,8,
        }
    }
    
    Scope (_SB.PCI0.ACEL)
    {
        Method (CLRI, 0, Serialized)
        {
            Store (Zero, Local0)
            If (LEqual (^^LPCB.EC.ECOK, One))
            {
                If (LEqual (^^LPCB.EC.SW2S, Zero))
                {
                    If (LEqual (^^^BAT0._STA (), 0x1F))
                    {
                        If (LLessEqual (B1B2(^^LPCB.EC.BRM0,^^LPCB.EC.BRM1), 0x96))
                        {
                            Store (One, Local0)
                        }
                    }
                }
            }

            Return (Local0)
        }
    }
    
    Scope (_SB)
    {
        Scope (BAT0)
        {
            //Added patched method UPBI
            Method (UPBI, 0, NotSerialized)
            {
                Store (B1B2(^^PCI0.LPCB.EC.FCC0,^^PCI0.LPCB.EC.FCC1), Local5)
                If (LAnd (Local5, LNot (And (Local5, 0x8000))))
                {
                    ShiftRight (Local5, 0x05, Local5)
                    ShiftLeft (Local5, 0x05, Local5)
                    Store (Local5, Index (PBIF, One))
                    Store (Local5, Index (PBIF, 0x02))
                    Divide (Local5, 0x64, , Local2)
                    Add (Local2, One, Local2)
                    If (LLess (B1B2(^^PCI0.LPCB.EC.ADC0,^^PCI0.LPCB.EC.ADC1), 0x0C80))
                    {
                        Multiply (Local2, 0x0E, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x05))
                        Multiply (Local2, 0x09, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x06))
                        Multiply (Local2, 0x0B, Local4)
                    }
                    ElseIf (LEqual (SMA4, One))
                    {
                        Multiply (Local2, 0x0C, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x05))
                        Multiply (Local2, 0x07, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x06))
                        Multiply (Local2, 0x09, Local4)
                    }
                    Else
                    {
                        Multiply (Local2, 0x0A, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x05))
                        Multiply (Local2, 0x05, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x06))
                        Multiply (Local2, 0x07, Local4)
                    }

                    Add (Local4, 0x02, FABL)
                }

                If (^^PCI0.LPCB.EC.MBNH)
                {
                    Store (^^PCI0.LPCB.EC.BVLB, Local0)
                    Store (^^PCI0.LPCB.EC.BVHB, Local1)
                    ShiftLeft (Local1, 0x08, Local1)
                    Or (Local0, Local1, Local0)
                    Store (Local0, Index (PBIF, 0x04))
                    Store ("OANI$", Index (PBIF, 0x09))
                    Store ("NiMH", Index (PBIF, 0x0B))
                }
                Else
                {
                    Store (^^PCI0.LPCB.EC.BVLB, Local0)
                    Store (^^PCI0.LPCB.EC.BVHB, Local1)
                    ShiftLeft (Local1, 0x08, Local1)
                    Or (Local0, Local1, Local0)
                    Store (Local0, Index (PBIF, 0x04))
                    Sleep (0x32)
                    Store ("LION", Index (PBIF, 0x0B))
                }

                Store ("Primary", Index (PBIF, 0x09))
                UPUM ()
                Store (One, Index (PBIF, Zero))
            }
            
            //Added patched method UPBS
            Method (UPBS, 0, NotSerialized)
            {
                Store (B1B2(^^PCI0.LPCB.EC.CUR0,^^PCI0.LPCB.EC.CUR1), Local0)
                If (And (Local0, 0x8000))
                {
                    If (LEqual (Local0, 0xFFFF))
                    {
                        Store (Ones, Index (PBST, One))
                    }
                    Else
                    {
                        Not (Local0, Local1)
                        Increment (Local1)
                        And (Local1, 0xFFFF, Local3)
                        Store (Local3, Index (PBST, One))
                    }
                }
                Else
                {
                    Store (Local0, Index (PBST, One))
                }

                Store (B1B2(^^PCI0.LPCB.EC.BRM0,^^PCI0.LPCB.EC.BRM1), Local5)
                If (LNot (And (Local5, 0x8000)))
                {
                    ShiftRight (Local5, 0x05, Local5)
                    ShiftLeft (Local5, 0x05, Local5)
                    If (LNotEqual (Local5, DerefOf (Index (PBST, 0x02))))
                    {
                        Store (Local5, Index (PBST, 0x02))
                    }
                }

                If (LAnd (LNot (^^PCI0.LPCB.EC.SW2S), LEqual (^^PCI0.LPCB.EC.BACR, One)))
                {
                    Store (FABL, Index (PBST, 0x02))
                }

                Store (B1B2(^^PCI0.LPCB.EC.BCV0,^^PCI0.LPCB.EC.BCV1), Index (PBST, 0x03))
                Store (^^PCI0.LPCB.EC.MBST, Index (PBST, Zero))
            }
        }
        
        Scope (WMID)
        {
            Method (GBIF, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x7 (BIOS Read)", Debug)
                Acquire (^^PCI0.LPCB.EC.MUT1, 0xFFFF)
                If (LNot (^^PCI0.LPCB.EC.ECOK))
                {
                    Store (Package (0x02)
                        {
                            0x0D, 
                            Zero
                        }, Local0)
                    Sleep (0x96)
                    Release (^^PCI0.LPCB.EC.MUT1)
                    Return (Local0)
                }

                If (Arg0)
                {
                    Store (Package (0x02)
                        {
                            0x06, 
                            Zero
                        }, Local0)
                    Sleep (0x96)
                    Release (^^PCI0.LPCB.EC.MUT1)
                    Return (Local0)
                }

                If (LNot (^^PCI0.LPCB.EC.MBTS))
                {
                    Store (Package (0x02)
                        {
                            0x34, 
                            Zero
                        }, Local0)
                    Sleep (0x96)
                    Release (^^PCI0.LPCB.EC.MUT1)
                    Return (Local0)
                }

                If (LNotEqual (^^PCI0.LPCB.EC.BTVD, One))
                {
                    Store (Package (0x02)
                        {
                            0x37, 
                            Zero
                        }, Local0)
                    Sleep (0x96)
                    Release (^^PCI0.LPCB.EC.MUT1)
                    Return (Local0)
                }
                ElseIf (LEqual (And (^^PCI0.LPCB.EC.MBDC, 0x10), 0x10))
                {
                    Store (Package (0x02)
                        {
                            0x36, 
                            Zero
                        }, Local0)
                    Sleep (0x96)
                    Release (^^PCI0.LPCB.EC.MUT1)
                    Return (Local0)
                }

                Store (Package (0x03)
                    {
                        Zero, 
                        0x80, 
                        Buffer (0x80) {}
                    }, Local0)
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x18, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), One))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), Zero))
                Store (B1B2(^^PCI0.LPCB.EC.FCC0,^^PCI0.LPCB.EC.FCC1), Local1)
                ShiftRight (Local1, 0x05, Local1)
                ShiftLeft (Local1, 0x05, Local1)
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x0F, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x05))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x04))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x0C, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x07))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x06))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x17, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x09))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x08))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x08, RefOf (Local1))
                Subtract (Local1, 0x0AAA, Local1)
                Divide (Local1, 0x0A, Local2, Local1)
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0A))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x09, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0D))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0C))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x0A, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0F))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0E))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x19, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x11))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x10))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x16, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x13))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x12))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x3F, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x15))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x14))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x3E, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x17))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x16))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x3D, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x19))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x18))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x3C, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x1B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x1A))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x1C, RefOf (Local1))
                Store (ITOS (ToBCD (Local1)), Local3)
                Store (0x1C, Local2)
                Store (Zero, Local4)
                Store (SizeOf (Local3), Local1)
                While (Local1)
                {
                    GBFE (Local3, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local4)
                }

                Store (0x20, Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x1B, RefOf (Local1))
                And (Local1, 0x1F, Local7)
                Store (ITOS (ToBCD (Local7)), Local6)
                And (Local1, 0x01E0, Local7)
                ShiftRight (Local7, 0x05, Local7)
                Store (ITOS (ToBCD (Local7)), Local5)
                ShiftRight (Local1, 0x09, Local7)
                Add (Local7, 0x07BC, Local7)
                Store (ITOS (ToBCD (Local7)), Local4)
                Store (0x02, Local1)
                Store (0x03, Local7)
                While (Local1)
                {
                    GBFE (Local5, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store ("/", Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                Store (0x02, Local1)
                Store (0x03, Local7)
                While (Local1)
                {
                    GBFE (Local6, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store ("/", Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                Store (0x04, Local1)
                Store (One, Local7)
                While (Local1)
                {
                    GBFE (Local4, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store (Zero, Index (DerefOf (Index (Local0, 0x02)), Local2))
                ^^PCI0.LPCB.EC.SMRD (0x0B, 0x16, 0x20, RefOf (Local1))
                Store (SizeOf (Local1), Local3)
                Store (0x2C, Local2)
                Store (Zero, Local4)
                While (Local3)
                {
                    GBFE (Local1, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local3)
                    Increment (Local2)
                    Increment (Local4)
                }

                ^^PCI0.LPCB.EC.SMRD (0x0B, 0x16, 0x70, RefOf (Local1))
                GBFE (Local1, Zero, RefOf (Local5))
                If (LEqual (Local5, 0x36))
                {
                    Store (SizeOf (Local1), Local3)
                    Store (0x3E, Local2)
                    Store (Zero, Local4)
                }
                Else
                {
                    Store (0x03, Local3)
                    Store (0x3E, Local2)
                    Store (Zero, Local4)
                    Store (Buffer (0x04)
                        {
                            "N/A"
                        }, Local1)
                }

                While (Local3)
                {
                    GBFE (Local1, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local3)
                    Increment (Local2)
                    Increment (Local4)
                }

                ^^PCI0.LPCB.EC.SMRD (0x0B, 0x16, 0x21, RefOf (Local1))
                Store (SizeOf (Local1), Local3)
                Store (0x4F, Local2)
                Store (Zero, Local4)
                While (Local3)
                {
                    GBFE (Local1, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local3)
                    Increment (Local2)
                    Increment (Local4)
                }

                ^^PCI0.LPCB.EC.SMRD (0x0B, 0x16, 0x22, RefOf (Local1))
                Store (SizeOf (Local1), Local3)
                Store (0x56, Local2)
                Store (Zero, Local4)
                While (Local3)
                {
                    GBFE (Local1, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local3)
                    Increment (Local2)
                    Increment (Local4)
                }

                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, Zero, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x5B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x5A))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x1B, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x5D))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x5C))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x14, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x5F))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x5E))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x15, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x61))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x60))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x0B, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x63))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x62))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x11, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x65))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x64))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x12, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x67))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x66))
                ^^PCI0.LPCB.EC.SMRD (0x09, 0x16, 0x13, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 0x69))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x68))
                Store (One, Index (DerefOf (Index (Local0, 0x02)), 0x6A))
                Sleep (0x96)
                Release (^^PCI0.LPCB.EC.MUT1)
                Return (Local0)
            }
            
            Method (GBCO, 0, Serialized)
            {
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                Store ("HP WMI Command 0x2B (BIOS Read)", Debug)
                Store (Package (0x03)
                    {
                        Zero, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                If (LEqual (^^PCI0.LPCB.EC.ECOK, One))
                {
                    If (^^PCI0.LPCB.EC.MBTS)
                    {
                        If (^^PCI0.LPCB.EC.BTVD)
                        {
                            If (^^PCI0.LPCB.EC.ACCC)
                            {
                                Store (^^PCI0.LPCB.EC.MBST, Local2)
                                And (Local2, 0x03, Local2)
                                While (One)
                                {
                                    Store (Local2, _T_0)
                                    If (LEqual (_T_0, Zero))
                                    {
                                        Store (^^PCI0.LPCB.EC.BDVO, Local1)
                                        If (LEqual (Local1, 0xC5))
                                        {
                                            Store (0x04, Local1)
                                        }
                                        Else
                                        {
                                            Store (Zero, Local1)
                                        }
                                    }
                                    ElseIf (LEqual (_T_0, One))
                                    {
                                        Store (0x02, Local1)
                                    }
                                    ElseIf (LEqual (_T_0, 0x02))
                                    {
                                        Store (B1B2(^^PCI0.LPCB.EC.CUR0,^^PCI0.LPCB.EC.CUR1), Local2)
                                        Store (0xC3, Local3)
                                        If (And (LLessEqual (Local2, 0x0200), LEqual (^^PCI0.LPCB.EC.BDVO, Local3)))
                                        {
                                            Store (0x03, Local1)
                                        }
                                        Else
                                        {
                                            Store (One, Local1)
                                        }
                                    }
                                    Else
                                    {
                                        Store (0x37, Index (DerefOf (Index (Local0, Zero)), Zero))
                                    }

                                    Break
                                }
                            }
                            Else
                            {
                                Store (0x02, Local1)
                            }
                        }
                        Else
                        {
                            Store (0x37, Index (DerefOf (Index (Local0, Zero)), Zero))
                        }
                    }
                    Else
                    {
                        Store (0xFF, Local1)
                    }

                    Store (Local1, Index (DerefOf (Index (Local0, 0x02)), Zero))
                    Store (0xFF, Index (DerefOf (Index (Local0, 0x02)), One))
                }
                Else
                {
                    Store (0x35, Index (DerefOf (Index (Local0, Zero)), Zero))
                }

                Return (Local0)
            }
        }
    }

    Scope (_SB.PCI0.LPCB.EC)
    {
        //Added patched method SMWR
        Method (SMWR, 4, NotSerialized)
        {
            If (LNot (ECOK))
            {
                Return (0xFF)
            }

            If (LNotEqual (Arg0, 0x06))
            {
                If (LNotEqual (Arg0, 0x08))
                {
                    If (LNotEqual (Arg0, 0x0A))
                    {
                        If (LNotEqual (Arg0, 0x46))
                        {
                            If (LNotEqual (Arg0, 0xC6))
                            {
                                Return (0x19)
                            }
                        }
                    }
                }
            }

            Acquire (MUT0, 0xFFFF)
            Store (0x04, Local0)
            While (LGreater (Local0, One))
            {
                If (LEqual (Arg0, 0x06))
                {
                    Store (Arg3, SMB0)
                }

                If (LEqual (Arg0, 0x46))
                {
                    Store (Arg3, SMB0)
                }

                If (LEqual (Arg0, 0xC6))
                {
                    Store (Arg3, SMB0)
                }

                If (LEqual (Arg0, 0x08))
                {
                    Store (Arg3, SMW0)
                }

                If (LEqual (Arg0, 0x0A))
                {
                    WECB(0x04,256,Arg3)
                }

                And (SMST, 0x40, SMST)
                Store (Arg2, SMCM)
                Store (Arg1, SMAD)
                Store (Arg0, SMPR)
                Store (Zero, Local3)
                While (LNot (And (SMST, 0xBF, Local1)))
                {
                    Sleep (0x02)
                    Increment (Local3)
                    If (LEqual (Local3, 0x32))
                    {
                        And (SMST, 0x40, SMST)
                        Store (Arg2, SMCM)
                        Store (Arg1, SMAD)
                        Store (Arg0, SMPR)
                        Store (Zero, Local3)
                    }
                }

                If (LEqual (Local1, 0x80))
                {
                    Store (Zero, Local0)
                }
                Else
                {
                    Decrement (Local0)
                }
            }

            If (Local0)
            {
                Store (And (Local1, 0x1F), Local0)
            }

            Release (MUT0)
            Return (Local0)
        }   
    }    
            
    Method (B1B2, 2, NotSerialized) { Return(Or(Arg0, ShiftLeft(Arg1, 8))) }
    
    //Added new methods from patch
    Scope (_SB.PCI0.LPCB)
    {
        Scope (EC)
        {
            Method (WE1B, 2, NotSerialized)
            {
                OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
                Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
                Store(Arg1, BYTE)
            }
            Method (WECB, 3, Serialized)
            // Arg0 - offset in bytes from zero-based EC
            // Arg1 - size of buffer in bits
            // Arg2 - value to write
            {
                ShiftRight(Arg1, 3, Arg1)
                Name(TEMP, Buffer(Arg1) { })
                Store(Arg2, TEMP)
                Add(Arg0, Arg1, Arg1)
                Store(0, Local0)
                While (LLess(Arg0, Arg1))
                {
                    WE1B(Arg0, DerefOf(Index(TEMP, Local0)))
                    Increment(Arg0)
                    Increment(Local0)
                }
            }
        }
    }
}