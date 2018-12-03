open Ocaml_common
open Parsetree
open Core

let parse_mli file =
    In_channel.with_file file ~binary:false ~f:(fun in_file ->
        let lexbuf = Lexing.from_channel in_file in
        Parser.interface Lexer.token lexbuf
    )

type ('k, 'v) map = ('k, 'v) Map.Poly.t

let create_map (f: 'a -> ('k * 'v) option) (xs: 'a list): ('k, 'v) map =
    let folder acc x =
        match f x with
        | Some (key, value) ->
            begin match Map.add acc ~key ~data:value with
            | `Ok result -> result
            | `Duplicate -> failwith "Duplicate key in map creation"
            end
        | None -> acc
    in
    List.fold_left ~f:folder ~init:Map.Poly.empty xs

let () =
    if Array.length Sys.argv <> 5
    then begin
        Printf.eprintf "Usage: %s file.mli git_repo git_commit git_timestamp\n" Sys.argv.(0);
        exit 1
    end

let () = Lexer.init()
let filename = Sys.argv.(1)
let git_repo = Sys.argv.(2)
let git_commit = Sys.argv.(3)
let git_timestamp = Sys.argv.(4)
let ast = parse_mli filename
let get_name_and_type_of_val (item: signature_item): (string * core_type) option =
    match item.psig_desc with
    | Psig_value value_desc -> Some (value_desc.pval_name.txt, value_desc.pval_type)
    | _ -> None

let file_types = create_map get_name_and_type_of_val ast
let () = Map.iteri file_types ~f:(fun ~key:name ~data ->
    Format.set_margin 10010;
    Format.set_max_indent 10000;
    Format.printf "\"%s\",\"%s\",\"%s\",\"%s\",\"%a\",\"%s\"@." git_repo filename name git_timestamp Pprintast.core_type data git_commit
)
