(******************************************************************************)
(*                                ASLRef                                      *)
(******************************************************************************)
(*
 * SPDX-FileCopyrightText: Copyright 2022-2023 Arm Limited and/or its affiliates <open-source-office@arm.com>
 * SPDX-License-Identifier: BSD-3-Clause
 *)
(******************************************************************************)
(* Disclaimer:                                                                *)
(* This material covers both ASLv0 (viz, the existing ASL pseudocode language *)
(* which appears in the Arm Architecture Reference Manual) and ASLv1, a new,  *)
(* experimental, and as yet unreleased version of ASL.                        *)
(* This material is work in progress, more precisely at pre-Alpha quality as  *)
(* per Arm’s quality standards.                                               *)
(* In particular, this means that it would be premature to base any           *)
(* production tool development on this material.                              *)
(* However, any feedback, question, query and feature request would be most   *)
(* welcome; those can be sent to Arm’s Architecture Formal Team Lead          *)
(* Jade Alglave <jade.alglave@arm.com>, or by raising issues or PRs to the    *)
(* herdtools7 github repository.                                              *)
(******************************************************************************)

(*
  This file describes the bnfc AST and defines a few utility functions to print and update the contained data
 *)

(* Define BNFC data types *)
type term =
  | Literal of string
  (* Literal which is referenced via a token name. Can be replaced by a literal in the future *)
  | LitReference of string
  | Reference of string

type decl = { ast_name : string; name : string; terms : term list }
type bnfc = { entrypoints : string list; decls : decl list }

(*
   BNFC data structure utilities
 *)

(** Group decl lists into a list of lists where each sub-list has a common name *)
let rec group_by_name decl_list =
  match decl_list with
  | [] -> []
  | { name } :: _ ->
      let common, rest =
        List.partition
          (fun { name = name2 } -> String.equal name name2)
          decl_list
      in
      common :: group_by_name rest

(** Conevert bnfc declaration terms to string *)
let string_of_term term =
  match term with
  | Literal str -> "\"" ^ str ^ "\""
  | LitReference id | Reference id -> id

let string_of_entrypoints eps =
  Printf.sprintf "entrypoints %s;" (String.concat ", " eps)

(** Conert the bnfc type to string *)
let string_of_bnfc bnfc =
  let print_decl_list decl_list =
    let longest_name { ast_name } acc = max acc (String.length ast_name) in
    let max_name = List.fold_right longest_name decl_list 0 in
    let print_decl { ast_name; name; terms } =
      let terms_str = String.concat " " @@ List.map string_of_term terms in
      let space = String.make (max_name - String.length ast_name) ' ' in
      Printf.sprintf "%s. %s%s ::= %s;" ast_name space name terms_str
    in
    let decl_strs = List.map print_decl decl_list in
    String.concat "\n" decl_strs
  in
  let grouped_decls = group_by_name bnfc.decls in
  let eps = string_of_entrypoints bnfc.entrypoints in
  let decl_strs = List.map print_decl_list grouped_decls in
  String.concat "\n\n" (eps :: decl_strs)

