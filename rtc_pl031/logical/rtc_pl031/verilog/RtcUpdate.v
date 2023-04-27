//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 2022 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  and copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information :
//
//
//  Filename            : RtcUpdate.v.rca
//
//  File Revision       : 1.10
//    @ Ahmed Abdelazeem
//  Release Information : PrimeCell(TM)-PL031-REL1v0
//
//------------------------------------------------------------------------------
// Purpose : This block contains the update logic for the RTC
//
//------------------------------------------------------------------------------


`timescale 1ns/1ps


module RtcUpdate (
                // Inputs
        input wire         PCLK,           // APB clock
        input wire         PRESETn,        // AMBA reset
        input wire         nPOR,           // Power on reset
        input wire  [31:0] CountSync,      // Synchronised count value
        input wire  [31:0] RTCMR,          // RTC Match register
        input wire  [31:0] RTCLR,          // RTC Load register
        input wire  [31:0] RTCTOFFSET,     // RTC test offset register
        input wire         TESTOFFSET,     // Test offset enable
        input wire         RTCEn,          // RTC enable signal
        input wire         WrenRTCLR,      // Write enable for RTCLR
        input wire         WrenRTCMR,      // Write enable for RTCMR
        input wire         CountEdge,      // Counter increment signal
        // Outputs
        output reg  [31:0] RtcValue,       // Updated RTC value
        output reg  [31:0] Offset,         // Calculated offset value
        output reg  [31:0] MatchData       // Equivalent match value
                  );


//------------------------------------------------------------------------------
//
//                             RtcUpdate
//                             =========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
// This block performs the following functions.
//
// Generation of the equivalent match value from RTCMR
//
// Generation of the Offset value as a difference between the Count value and
// the Update value (RTCLR).
//
// Generation of the absolute RTC value as a difference between the Count value
// and the Offset value.
//
//==============================================================================

//------------------------------------------------------------------------------
// Wire Declarations
//------------------------------------------------------------------------------
reg  [ 1:0] UpdateNextState; // Next state of Update next state logic
reg  [31:0] InputA;          // A input of Adder/Subtractor
reg  [31:0] InputB;          // B input of Adder/Subtractor
reg  [31:0] Sum;             // Output of Adder/Subtractor
reg         Carry;           // Carry signal for adders

//------------------------------------------------------------------------------
// Register Declarations
//------------------------------------------------------------------------------

reg [31:0] NextOffset;      // D-input of OffsetData
reg [31:0] NextRtcValue;    // D-input of RtcValue
reg [31:0] NextMatchData;   // D-input of MatchData
reg [ 1:0] UpdateState;     // Current state of Next State logic

//------------------------------------------------------------------------------
// State machine defines
//------------------------------------------------------------------------------
`define ST_IDLE       2'b00 // Idle state, initialisations
`define ST_OFFSET     2'b01 // Offset value calculated in this state
`define ST_RTCVALUE   2'b10 // RTC value calculated in this state
`define ST_MATCHDATA  2'b11 // Matchdata calculated in this state
//------------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// State Transition process
//------------------------------------------------------------------------------
// UpdateState
always@(posedge PCLK or negedge nPOR)
  begin : SeqUpdateState
    if (nPOR == 1'b0)
      UpdateState <= `ST_IDLE;
    else
      UpdateState <= UpdateNextState;
  end // SeqUpdateState

// RtcValue
always@(posedge PCLK or negedge nPOR)
  begin : SeqRtcValue
    if (nPOR == 1'b0)
      RtcValue <= 32'h00000000;
    else
      RtcValue <= NextRtcValue;
  end // SeqRtcValue

// MatchData
always@(posedge PCLK or negedge nPOR)
  begin : SeqMatchData
    if (nPOR == 1'b0)
      MatchData <= 32'h00000000;
    else
      MatchData <= NextMatchData;
  end // SeqMatchData

// Offset
always@(posedge PCLK or negedge nPOR)
  begin : SeqOffset
    if (nPOR == 1'b0)
      Offset <= 32'h00000000;
    else if (TESTOFFSET == 1'b1)
           Offset <= RTCTOFFSET;
         else
           Offset <= NextOffset;
  end // SeqOffset


// Adder
always@(InputA or InputB or Carry)
  begin : CombAdder
    Sum = InputA + InputB + Carry;
  end // CombAdder


//------------------------------------------------------------------------------
// Output and Next State Logic generation
//------------------------------------------------------------------------------
always@(UpdateState or RtcValue or Offset or MatchData or CountEdge or WrenRTCLR
        or WrenRTCMR or CountSync or RTCLR or RTCEn or Sum or RTCMR)
  begin : CombUpdateState
    // Default assignments

    UpdateNextState  = UpdateState;
    NextRtcValue     = RtcValue;
    NextOffset       = Offset;
    NextMatchData    = MatchData;
    Carry            = 1'b0;


    case (UpdateState)

      `ST_IDLE :
        // Default state
        begin
          InputA = 32'h00000000;
          InputB = 32'h00000000;
          Carry = 1'b0;
          if (WrenRTCLR == 1'b1)
            UpdateNextState = `ST_OFFSET;
          else if (CountEdge == 1'b1)
            UpdateNextState = `ST_RTCVALUE;
          else if (WrenRTCMR == 1'b1)
            UpdateNextState = `ST_MATCHDATA;
          else
            UpdateNextState = `ST_IDLE;
        end // case: 2'b00

      `ST_OFFSET :
        // New load value written to RTCLR, so  new offset value calculated
        begin
          InputA   = CountSync;
          InputB   = ~RTCLR;
          Carry    = 1'b1;
          NextOffset =  Sum;
          UpdateNextState = `ST_RTCVALUE;
        end // case: 2'b01

      `ST_RTCVALUE :
        // Update RTC value either due to an increment in the counter

        begin
          InputA  = CountSync;
          InputB  = ~Offset;
          Carry   = 1'b1;
          if (RTCEn == 1'b1)
            NextRtcValue = Sum;
          else
            NextRtcValue = 32'h00000000;

          if (WrenRTCLR == 1'b1)
            UpdateNextState = `ST_OFFSET;
          else
            UpdateNextState = `ST_MATCHDATA;
        end // case: 2'b10

      `ST_MATCHDATA :
        // Update equivalent RTC Match Register value either due to a write to
        // the RTC Match Register

        begin
          InputA         = RTCMR;
          InputB         = Offset;
          Carry          = 1'b0;
          NextMatchData  = Sum;
          if (WrenRTCLR == 1'b1)
            UpdateNextState = `ST_OFFSET;
          else
            UpdateNextState = `ST_IDLE;
        end // case: 2'b11

      default :

        UpdateNextState = `ST_IDLE;

    endcase // case(UpdateState)
  end // CombUpdateState



endmodule

//====================End of RtcRegBlk==========================================
