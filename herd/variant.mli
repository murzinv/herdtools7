(****************************************************************************)
(*                           the diy toolsuite                              *)
(*                                                                          *)
(* Jade Alglave, University College London, UK.                             *)
(* Luc Maranget, INRIA Paris-Rocquencourt, France.                          *)
(*                                                                          *)
(* Copyright 2018-present Institut National de Recherche en Informatique et *)
(* en Automatique and the authors. All rights reserved.                     *)
(*                                                                          *)
(* This software is governed by the CeCILL-B license under French law and   *)
(* abiding by the rules of distribution of free software. You can use,      *)
(* modify and/ or redistribute the software under the terms of the CeCILL-B *)
(* license as circulated by CEA, CNRS and INRIA at the following URL        *)
(* "http://www.cecill.info". We also give a copy in LICENSE.txt.            *)
(****************************************************************************)

type t =
  | Success     (* Riscv Model with explicit success dependency *)
  | Instr       (* Define "instr" relation, ie generated by the same
                   instruction instance *)
  | SpecialX0   (* Some events by AMO to or from x0 are not generated *)
  | NoRMW       (* No RMW event for C *)
  | AcqRelAsFence (* Riscv: Expand load acquire and store release as fences *)
  | BackCompat (* Linux, Backward compatibility -> LISA *)
  | FullScDepend    (* Complete dependencies for Store Conditinal *)
  | SplittedRMW  (* Splitted RMW events for riscv *)
  | SwitchDepScWrite     (* Switch dependency on sc mem write, riscv *)
  | SwitchDepScResult    (* Switch dependency from address read to sc result write, riscv,aarch64 *)
  | LrScDiffOk      (* Lr/Sc paired to <> addresses may succeed (!) *)
  | NotWeakPredicated (* NOT "Weak" predicated instructions, not performing non-selected events, aarch64 *)
(* Mixed size *)
  | Mixed
  | Unaligned
 (* Do not check (and reject early) mixed size tests in non-mixed-size mode *)
  | DontCheckMixed
  | MemTag           (* Memory Tagging *)
  | TagCheckPrecise
  | TagCheckUnprecise
  | TooFar         (* Do not discard candidates with TooFar events *)
  | Morello
  | Neon
(* Branch speculation+ cat computation of dependencies *)
  | Deps
  | Instances (* Compute dependencies on instruction instances *)
  | Kvm
  | ETS
(* Do not insert branching event between pte read and accesses *)
  | NoPteBranch
(* Pte-Squared: all accesses through page table, including PT accesses *)
  | PTE2
(* Generate extra spurious updates based upon load on pte. *)
  | PhantomOnLoad
(* Optimise Rf enumeration leading to rmw *)
  | OptRfRMW
(* Allow some constrained unpredictable, behaviours.
   AArch64: LDXR / STXR of different size or address may succeed. *)
  | ConstrainedUnpredictable
(* Perform experiment *)
  | Exp

val compare : t -> t -> int
val tags : string list
val parse : string -> t option
val pp : t -> string

(* switch variant that flips an arch-dependent, default value *)
val get_default :  Archs.t -> t -> bool

(* Get value for switchable variant *)
val get_switch : Archs.t -> t -> (t -> bool) -> bool

(* set precision *)
val set_precision : bool ref -> t -> bool
