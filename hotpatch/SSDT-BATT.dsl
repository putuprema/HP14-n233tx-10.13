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
    External(BCNT, FieldUnitObj)
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
            SMPR,   8, 
            SMST,   8, 
            SMAD,   8, 
            SMCM,   8, 
            SD00,8,SD01,8,SD02,8,SD03,8,
            SD04,8,SD05,8,SD06,8,SD07,8,
            SD08,8,SD09,8,SD0A,8,SD0B,8,   
            SD0C,8,SD0D,8,SD0E,8,SD0F,8,
            SD10,8,SD11,8,SD12,8,SD13,8,
            SD14,8,SD15,8,SD16,8,SD17,8,
            SD18,8,SD19,8,SD1A,8,SD1B,8,
            SD1C,8,SD1D,8,SD1E,8,SD1F,8, 
            Offset (0x70), 
            ADC0,8,ADC1,8, 
            FCC0,8,FCC1,8, 
            Offset (0x83),
            CUR0,8,CUR1,8, 
            BRM0,8,BRM1,8, 
            BCV0,8,BCV1,8,
        }
        
        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            SMWX,8,SMWY,8
        }

        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            F000,8,F001,8,F002,8,F003,8,
            F004,8,F005,8,F006,8,F007,8,
        }

        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            F100,8,F101,8,F102,8,F103,8,
            F104,8,F105,8,F106,8,F107,8,
            F108,8,F109,8,F10A,8,F10B,8,
            F10C,8,F10D,8,F10E,8,F10F,8,
        }

        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            F200,8,F201,8,F202,8,F203,8,
            F204,8,F205,8,F206,8,F207,8,
            F208,8,F209,8,F20A,8,F20B,8,
            F20C,8,F20D,8,F20E,8,F20F,8,
            F210,8,F211,8,F212,8,F213,8,
            F214,8,F215,8,F216,8,F217,8,
        }
      
        Field (ERM2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            F300,8,F301,8,F302,8,F303,8,
            F304,8,F305,8,F306,8,F307,8,
            F308,8,F309,8,F30A,8,F30B,8,
            F30C,8,F30D,8,F30E,8,F30F,8,
            F310,8,F311,8,F312,8,F313,8,
            F314,8,F315,8,F316,8,F317,8,
            F318,8,F319,8,F31A,8,F31B,8,
            F31C,8,F31D,8,F31E,8,F31F,8
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
                    Store (0xC80, Index (PBIF, One))
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
                    Store ("Li-ion", Index (PBIF, 0x0B))
                }

                Store ("LA04048", Index (PBIF, 0x09))
                Store ("0212", Index (PBIF, 0x0A))
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
                    Method (SMRD, 4, NotSerialized)
                    {
                        If (LNot (ECOK))
                        {
                            Return (0xFF)
                        }

                        If (LNotEqual (Arg0, 0x07))
                        {
                            If (LNotEqual (Arg0, 0x09))
                            {
                                If (LNotEqual (Arg0, 0x0B))
                                {
                                    If (LNotEqual (Arg0, 0x47))
                                    {
                                        If (LNotEqual (Arg0, 0xC7))
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
                        Else
                        {
                            If (LEqual (Arg0, 0x07))
                            {
                                Store (SMB0, Arg3)
                            }

                            If (LEqual (Arg0, 0x47))
                            {
                                Store (SMB0, Arg3)
                            }

                            If (LEqual (Arg0, 0xC7))
                            {
                                Store (SMB0, Arg3)
                            }

                            If (LEqual (Arg0, 0x09))
                            {
                                Store (B1B2(SMWX,SMWY), Arg3)
                            }

                            If (LEqual (Arg0, 0x0B))
                            {
                                Store (BCNT, Local3)
                                ShiftRight (0x0100, 0x03, Local2)
                                If (LGreater (Local3, Local2))
                                {
                                    Store (Local2, Local3)
                                }

                                If (LLess (Local3, 0x09))
                                {
                                    Store (RFL0(), Local2)
                                }
                                ElseIf (LLess (Local3, 0x11))
                                {
                                    Store (RFL1(), Local2)
                                }
                                ElseIf (LLess (Local3, 0x19))
                                {
                                    Store (RFL2(), Local2)
                                }
                                Else
                                {
                                    Store (RFL3(), Local2)
                                }

                                Increment (Local3)
                                Store (Buffer (Local3) {}, Local4)
                                Decrement (Local3)
                                Store (Zero, Local5)
                                While (LGreater (Local3, Local5))
                                {
                                    GBFE (Local2, Local5, RefOf (Local6))
                                    PBFE (Local4, Local5, Local6)
                                    Increment (Local5)
                                }

                                PBFE (Local4, Local5, Zero)
                                Store (Local4, Arg3)
                            }
                        }

                        Release (MUT0)
                        Return (Local0)
                    }

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
                    Store(Arg3, SMWX) Store(ShiftRight(Arg3, 8), SMWY) 
                }

                If (LEqual (Arg0, 0x0A))
                {
                    WSMD(Arg3)
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
                    Method (RSMD, 0, Serialized)
                    {
                        Name (TEMP, Buffer(0x20) { })
                        Store (SD00, Index(TEMP, 0x00))
                        Store (SD01, Index(TEMP, 0x01))
                        Store (SD02, Index(TEMP, 0x02))
                        Store (SD03, Index(TEMP, 0x03))
                        Store (SD04, Index(TEMP, 0x04))
                        Store (SD05, Index(TEMP, 0x05))
                        Store (SD06, Index(TEMP, 0x06))
                        Store (SD07, Index(TEMP, 0x07))
                        Store (SD08, Index(TEMP, 0x08))
                        Store (SD09, Index(TEMP, 0x09))
                        Store (SD0A, Index(TEMP, 0x0A))
                        Store (SD0B, Index(TEMP, 0x0B))
                        Store (SD0C, Index(TEMP, 0x0C))
                        Store (SD0D, Index(TEMP, 0x0D))
                        Store (SD0E, Index(TEMP, 0x0E))
                        Store (SD0F, Index(TEMP, 0x0F))
                        Store (SD10, Index(TEMP, 0x10))
                        Store (SD11, Index(TEMP, 0x11))
                        Store (SD12, Index(TEMP, 0x12))
                        Store (SD13, Index(TEMP, 0x13))
                        Store (SD14, Index(TEMP, 0x14))
                        Store (SD15, Index(TEMP, 0x15))
                        Store (SD16, Index(TEMP, 0x16))
                        Store (SD17, Index(TEMP, 0x17))
                        Store (SD18, Index(TEMP, 0x18))
                        Store (SD19, Index(TEMP, 0x19))
                        Store (SD1A, Index(TEMP, 0x1A))
                        Store (SD1B, Index(TEMP, 0x1B))
                        Store (SD1C, Index(TEMP, 0x1C))
                        Store (SD1D, Index(TEMP, 0x1D))
                        Store (SD1E, Index(TEMP, 0x1E))
                        Store (SD1F, Index(TEMP, 0x1F))
                        Return (TEMP)
                    }
                    Method (WSMD, 1, Serialized)
                    {
                        Name (TEMP, Buffer(0x20) { })
                        Store (Arg0, TEMP)
                        Store (DerefOf(Index(TEMP, 0x00)), SD00)
                        Store (DerefOf(Index(TEMP, 0x01)), SD01)
                        Store (DerefOf(Index(TEMP, 0x02)), SD02)
                        Store (DerefOf(Index(TEMP, 0x03)), SD03)
                        Store (DerefOf(Index(TEMP, 0x04)), SD04)
                        Store (DerefOf(Index(TEMP, 0x05)), SD05)
                        Store (DerefOf(Index(TEMP, 0x06)), SD06)
                        Store (DerefOf(Index(TEMP, 0x07)), SD07)
                        Store (DerefOf(Index(TEMP, 0x08)), SD08)
                        Store (DerefOf(Index(TEMP, 0x09)), SD09)
                        Store (DerefOf(Index(TEMP, 0x0A)), SD0A)
                        Store (DerefOf(Index(TEMP, 0x0B)), SD0B)
                        Store (DerefOf(Index(TEMP, 0x0C)), SD0C)
                        Store (DerefOf(Index(TEMP, 0x0D)), SD0D)
                        Store (DerefOf(Index(TEMP, 0x0E)), SD0E)
                        Store (DerefOf(Index(TEMP, 0x0F)), SD0F)
                        Store (DerefOf(Index(TEMP, 0x10)), SD10)
                        Store (DerefOf(Index(TEMP, 0x11)), SD11)
                        Store (DerefOf(Index(TEMP, 0x12)), SD12)
                        Store (DerefOf(Index(TEMP, 0x13)), SD13)
                        Store (DerefOf(Index(TEMP, 0x14)), SD14)
                        Store (DerefOf(Index(TEMP, 0x15)), SD15)
                        Store (DerefOf(Index(TEMP, 0x16)), SD16)
                        Store (DerefOf(Index(TEMP, 0x17)), SD17)
                        Store (DerefOf(Index(TEMP, 0x18)), SD18)
                        Store (DerefOf(Index(TEMP, 0x19)), SD19)
                        Store (DerefOf(Index(TEMP, 0x1A)), SD1A)
                        Store (DerefOf(Index(TEMP, 0x1B)), SD1B)
                        Store (DerefOf(Index(TEMP, 0x1C)), SD1C)
                        Store (DerefOf(Index(TEMP, 0x1D)), SD1D)
                        Store (DerefOf(Index(TEMP, 0x1E)), SD1E)
                        Store (DerefOf(Index(TEMP, 0x1F)), SD1F)
                    }
                    Method (RFL3, 0, Serialized)
                    {
                        Name (TEMP, Buffer(0x20) { })
                        Store (F300, Index(TEMP, 0x00))
                        Store (F301, Index(TEMP, 0x01))
                        Store (F302, Index(TEMP, 0x02))
                        Store (F303, Index(TEMP, 0x03))
                        Store (F304, Index(TEMP, 0x04))
                        Store (F305, Index(TEMP, 0x05))
                        Store (F306, Index(TEMP, 0x06))
                        Store (F307, Index(TEMP, 0x07))
                        Store (F308, Index(TEMP, 0x08))
                        Store (F309, Index(TEMP, 0x09))
                        Store (F30A, Index(TEMP, 0x0A))
                        Store (F30B, Index(TEMP, 0x0B))
                        Store (F30C, Index(TEMP, 0x0C))
                        Store (F30D, Index(TEMP, 0x0D))
                        Store (F30E, Index(TEMP, 0x0E))
                        Store (F30F, Index(TEMP, 0x0F))
                        Store (F310, Index(TEMP, 0x10))
                        Store (F311, Index(TEMP, 0x11))
                        Store (F312, Index(TEMP, 0x12))
                        Store (F313, Index(TEMP, 0x13))
                        Store (F314, Index(TEMP, 0x14))
                        Store (F315, Index(TEMP, 0x15))
                        Store (F316, Index(TEMP, 0x16))
                        Store (F317, Index(TEMP, 0x17))
                        Store (F318, Index(TEMP, 0x18))
                        Store (F319, Index(TEMP, 0x19))
                        Store (F31A, Index(TEMP, 0x1A))
                        Store (F31B, Index(TEMP, 0x1B))
                        Store (F31C, Index(TEMP, 0x1C))
                        Store (F31D, Index(TEMP, 0x1D))
                        Store (F31E, Index(TEMP, 0x1E))
                        Store (F31F, Index(TEMP, 0x1F))
                        Return (TEMP)
                    }
                    /*
                    Method (WFL3, 1, Serialized)
                    {
                        Name (TEMP, Buffer(0x20) { })
                        Store (Arg0, TEMP)
                        Store (DerefOf(Index(TEMP, 0x00)), F300)
                        Store (DerefOf(Index(TEMP, 0x01)), F301)
                        Store (DerefOf(Index(TEMP, 0x02)), F302)
                        Store (DerefOf(Index(TEMP, 0x03)), F303)
                        Store (DerefOf(Index(TEMP, 0x04)), F304)
                        Store (DerefOf(Index(TEMP, 0x05)), F305)
                        Store (DerefOf(Index(TEMP, 0x06)), F306)
                        Store (DerefOf(Index(TEMP, 0x07)), F307)
                        Store (DerefOf(Index(TEMP, 0x08)), F308)
                        Store (DerefOf(Index(TEMP, 0x09)), F309)
                        Store (DerefOf(Index(TEMP, 0x0A)), F30A)
                        Store (DerefOf(Index(TEMP, 0x0B)), F30B)
                        Store (DerefOf(Index(TEMP, 0x0C)), F30C)
                        Store (DerefOf(Index(TEMP, 0x0D)), F30D)
                        Store (DerefOf(Index(TEMP, 0x0E)), F30E)
                        Store (DerefOf(Index(TEMP, 0x0F)), F30F)
                        Store (DerefOf(Index(TEMP, 0x10)), F310)
                        Store (DerefOf(Index(TEMP, 0x11)), F311)
                        Store (DerefOf(Index(TEMP, 0x12)), F312)
                        Store (DerefOf(Index(TEMP, 0x13)), F313)
                        Store (DerefOf(Index(TEMP, 0x14)), F314)
                        Store (DerefOf(Index(TEMP, 0x15)), F315)
                        Store (DerefOf(Index(TEMP, 0x16)), F316)
                        Store (DerefOf(Index(TEMP, 0x17)), F317)
                        Store (DerefOf(Index(TEMP, 0x18)), F318)
                        Store (DerefOf(Index(TEMP, 0x19)), F319)
                        Store (DerefOf(Index(TEMP, 0x1A)), F31A)
                        Store (DerefOf(Index(TEMP, 0x1B)), F31B)
                        Store (DerefOf(Index(TEMP, 0x1C)), F31C)
                        Store (DerefOf(Index(TEMP, 0x1D)), F31D)
                        Store (DerefOf(Index(TEMP, 0x1E)), F31E)
                        Store (DerefOf(Index(TEMP, 0x1F)), F31F)
                    }
                    */
                    Method (RFL2, 0, Serialized)
                    {
                        Name (TEMP, Buffer(0x18) { })
                        Store (F200, Index(TEMP, 0x00))
                        Store (F201, Index(TEMP, 0x01))
                        Store (F202, Index(TEMP, 0x02))
                        Store (F203, Index(TEMP, 0x03))
                        Store (F204, Index(TEMP, 0x04))
                        Store (F205, Index(TEMP, 0x05))
                        Store (F206, Index(TEMP, 0x06))
                        Store (F207, Index(TEMP, 0x07))
                        Store (F208, Index(TEMP, 0x08))
                        Store (F209, Index(TEMP, 0x09))
                        Store (F20A, Index(TEMP, 0x0A))
                        Store (F20B, Index(TEMP, 0x0B))
                        Store (F20C, Index(TEMP, 0x0C))
                        Store (F20D, Index(TEMP, 0x0D))
                        Store (F20E, Index(TEMP, 0x0E))
                        Store (F20F, Index(TEMP, 0x0F))
                        Store (F210, Index(TEMP, 0x10))
                        Store (F211, Index(TEMP, 0x11))
                        Store (F212, Index(TEMP, 0x12))
                        Store (F213, Index(TEMP, 0x13))
                        Store (F214, Index(TEMP, 0x14))
                        Store (F215, Index(TEMP, 0x15))
                        Store (F216, Index(TEMP, 0x16))
                        Store (F217, Index(TEMP, 0x17))
                        Return (TEMP)
                    }
                    /*
                    Method (WFL2, 1, Serialized)
                    {
                        Name (TEMP, Buffer(0x18) { })
                        Store (Arg0, TEMP)
                        Store (DerefOf(Index(TEMP, 0x00)), F200)
                        Store (DerefOf(Index(TEMP, 0x01)), F201)
                        Store (DerefOf(Index(TEMP, 0x02)), F202)
                        Store (DerefOf(Index(TEMP, 0x03)), F203)
                        Store (DerefOf(Index(TEMP, 0x04)), F204)
                        Store (DerefOf(Index(TEMP, 0x05)), F205)
                        Store (DerefOf(Index(TEMP, 0x06)), F206)
                        Store (DerefOf(Index(TEMP, 0x07)), F207)
                        Store (DerefOf(Index(TEMP, 0x08)), F208)
                        Store (DerefOf(Index(TEMP, 0x09)), F209)
                        Store (DerefOf(Index(TEMP, 0x0A)), F20A)
                        Store (DerefOf(Index(TEMP, 0x0B)), F20B)
                        Store (DerefOf(Index(TEMP, 0x0C)), F20C)
                        Store (DerefOf(Index(TEMP, 0x0D)), F20D)
                        Store (DerefOf(Index(TEMP, 0x0E)), F20E)
                        Store (DerefOf(Index(TEMP, 0x0F)), F20F)
                        Store (DerefOf(Index(TEMP, 0x10)), F210)
                        Store (DerefOf(Index(TEMP, 0x11)), F211)
                        Store (DerefOf(Index(TEMP, 0x12)), F212)
                        Store (DerefOf(Index(TEMP, 0x13)), F213)
                        Store (DerefOf(Index(TEMP, 0x14)), F214)
                        Store (DerefOf(Index(TEMP, 0x15)), F215)
                        Store (DerefOf(Index(TEMP, 0x16)), F216)
                        Store (DerefOf(Index(TEMP, 0x17)), F217)
                    }
                    */
                    Method (RFL1, 0, Serialized)
                    {
                        Name (TEMP, Buffer(0x10) { })
                        Store (F100, Index(TEMP, 0x00))
                        Store (F101, Index(TEMP, 0x01))
                        Store (F102, Index(TEMP, 0x02))
                        Store (F103, Index(TEMP, 0x03))
                        Store (F104, Index(TEMP, 0x04))
                        Store (F105, Index(TEMP, 0x05))
                        Store (F106, Index(TEMP, 0x06))
                        Store (F107, Index(TEMP, 0x07))
                        Store (F108, Index(TEMP, 0x08))
                        Store (F109, Index(TEMP, 0x09))
                        Store (F10A, Index(TEMP, 0x0A))
                        Store (F10B, Index(TEMP, 0x0B))
                        Store (F10C, Index(TEMP, 0x0C))
                        Store (F10D, Index(TEMP, 0x0D))
                        Store (F10E, Index(TEMP, 0x0E))
                        Store (F10F, Index(TEMP, 0x0F))
                        Return (TEMP)
                    }
                    /*
                    Method (WFL1, 1, Serialized)
                    {
                        Name (TEMP, Buffer(0x10) { })
                        Store (Arg0, TEMP)
                        Store (DerefOf(Index(TEMP, 0x00)), F100)
                        Store (DerefOf(Index(TEMP, 0x01)), F101)
                        Store (DerefOf(Index(TEMP, 0x02)), F102)
                        Store (DerefOf(Index(TEMP, 0x03)), F103)
                        Store (DerefOf(Index(TEMP, 0x04)), F104)
                        Store (DerefOf(Index(TEMP, 0x05)), F105)
                        Store (DerefOf(Index(TEMP, 0x06)), F106)
                        Store (DerefOf(Index(TEMP, 0x07)), F107)
                        Store (DerefOf(Index(TEMP, 0x08)), F108)
                        Store (DerefOf(Index(TEMP, 0x09)), F109)
                        Store (DerefOf(Index(TEMP, 0x0A)), F10A)
                        Store (DerefOf(Index(TEMP, 0x0B)), F10B)
                        Store (DerefOf(Index(TEMP, 0x0C)), F10C)
                        Store (DerefOf(Index(TEMP, 0x0D)), F10D)
                        Store (DerefOf(Index(TEMP, 0x0E)), F10E)
                        Store (DerefOf(Index(TEMP, 0x0F)), F10F)
                    }
                    */
                    Method (RFL0, 0, Serialized)
                    {
                        Name (TEMP, Buffer(0x10) { })
                        Store (F000, Index(TEMP, 0x00))
                        Store (F001, Index(TEMP, 0x01))
                        Store (F002, Index(TEMP, 0x02))
                        Store (F003, Index(TEMP, 0x03))
                        Store (F004, Index(TEMP, 0x04))
                        Store (F005, Index(TEMP, 0x05))
                        Store (F006, Index(TEMP, 0x06))
                        Store (F007, Index(TEMP, 0x07))
                        Return (TEMP)
                    }
                    /*
                    Method (WFL0, 1, Serialized)
                    {
                        Name (TEMP, Buffer(0x10) { })
                        Store (Arg0, TEMP)
                        Store (DerefOf(Index(TEMP, 0x00)), F000)
                        Store (DerefOf(Index(TEMP, 0x01)), F001)
                        Store (DerefOf(Index(TEMP, 0x02)), F002)
                        Store (DerefOf(Index(TEMP, 0x03)), F003)
                        Store (DerefOf(Index(TEMP, 0x04)), F004)
                        Store (DerefOf(Index(TEMP, 0x05)), F005)
                        Store (DerefOf(Index(TEMP, 0x06)), F006)
                        Store (DerefOf(Index(TEMP, 0x07)), F007)
                    }
                    */
                }
        }
}