module type Parser = sig
    include GenParser.S
    type parsedPseudo
    val instr_from_string : string -> parsedPseudo list
  end

module type Dumper = sig
    type pseudo
    val dump_info : 
      out_channel -> Name.t ->
      (MiscParser.state, (int * pseudo list) list,
       MiscParser.constr, MiscParser.location)
        MiscParser.result
      -> unit
end

module type S = sig
    include ArchBase.S

    type substitution =
      | Reg of string * reg
      | Cst of string * int
      | Lab of string * string
      | Addr of string * string
      | Code of string * pseudo list

    val dump_pseudos : pseudo list -> string

    val match_instruction : substitution list -> 
			    parsedPseudo -> pseudo ->
			    substitution list option

    val instanciate_with : substitution list -> reg list ->
			   parsedPseudo list ->
			   pseudo list
   					 
    module Parser : Parser with type parsedPseudo = parsedPseudo
			    and type pseudo = pseudo

    module Dumper : Dumper with type pseudo = pseudo
  end

module MakeParser : 
functor(A:ArchBase.S) ->
    functor
	 (P:sig
	      include GenParser.LexParse 
		      with type instruction = A.parsedPseudo
	      val instr_parser : 
	     (Lexing.lexbuf -> token) -> Lexing.lexbuf ->
	     A.parsedPseudo list
	    end)
       -> Parser
	    
val get_arch : Archs.t -> (module S)
