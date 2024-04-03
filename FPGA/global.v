`timescale 1ns/1ps

`define HIPRI_MAILBOXES_NUMBER 8
`define HIPRI_MAILBOXES_WIDTH $clog2(`HIPRI_MAILBOXES_NUMBER)
`define LOPRI_MAILBOXES_NUMBER 8
`define LOPRI_MAILBOXES_WIDTH $clog2(`LOPRI_MAILBOXES_NUMBER)

`define LOPRI_MSG_LENGTH 128
`define LOPRI_MSG_WIDTH $clog2(`LOPRI_MSG_LENGTH)
`define HIPRI_MSG_LENGTH 128
`define HIPRI_MSG_WIDTH $clog2(`HIPRI_MSG_LENGTH)

`define POINTER_WIDTH $clog2(`HIPRI_MAILBOXES_NUMBER*`HIPRI_MSG_LENGTH+`LOPRI_MAILBOXES_NUMBER*`LOPRI_MSG_LENGTH)

`define COMM_MEMORY_EMIF_WIDTH (`POINTER_WIDTH-2)