open MongoMessage;;


let wrap_unix f arg = 
  try (f arg) with
      Unix.Unix_error (e, fm, argm) ->
	Printf.printf "%s %s %s" (Unix.error_message e) fm argm;;

type t = Unix.file_descr;;

let create ip port = 
    let c_descr = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
    let s_addr = Unix.ADDR_INET ((Unix.inet_addr_of_string ip), port) in
    Unix.connect c_descr s_addr; 
    c_descr;;

let connect mongo_ip mongo_port =  
  create mongo_ip mongo_port;;

let connect_local mongo_port = 
  create "127.0.0.1" mongo_port;;

let close mongo = Unix.close mongo;;
  
let get_dbs m =
  let in_ch = Unix.in_channel_of_descr m in
  let out_ch = Unix.out_channel_of_descr m in
  output out_ch (dbs_cmd) 0 (String.length dbs_cmd);
  print_endline "sent dbs_cmd and waiting for answer";
  input_line in_ch;;
  (*Bson.decode (input_line in_ch);;*)
