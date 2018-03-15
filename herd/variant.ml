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
  | SpecialX0   (* Some events by AMO to or from x0 are not generated *)
  | NoRMW
(* Riscv: Expand load acquire and store release as fences *)
  | AcqRelAsFence
(* Backward compatibility *)
  | BackCompat
  | FullScDepend    (* Complete dependencies for Store Conditinal *)
  | SplittedRMW     (* Splitted RMW events for riscv *)
  | NoDepScWrite    (* No dependency on sc mem write, riscv *)

let tags =
  ["success";"specialx0";"normw";"acqrelasfence";"backcompat";
   "fullscdepend";"splittedrmw";"nodepscwrite"]

let parse s = match Misc.lowercase s with
| "success" -> Some Success
| "specialx0"|"amox0"|"x0" -> Some SpecialX0
| "normw" -> Some NoRMW
| "acqrelasfence" -> Some AcqRelAsFence
| "backcompat"|"back" -> Some BackCompat
| "fullscdepend"|"scdepend" -> Some FullScDepend
| "splittedrmw" -> Some SplittedRMW
| "nodepscwrite" -> Some  NoDepScWrite
| _ -> None

let pp = function
  | Success -> "success"
  | SpecialX0 -> "specialx0"
  | NoRMW -> "normw"
  | AcqRelAsFence -> "acqrelasfence"
  | BackCompat ->"backcompat"
  | FullScDepend -> "FullScDepend"
  | SplittedRMW -> "SplittedRWM"
  | NoDepScWrite -> "NoDepScWrite"

let compare = Pervasives.compare
