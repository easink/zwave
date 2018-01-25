defmodule Zwave.Consts do
  @moduledoc """
  Zwave constants
  """
  use Constants

  define zSOF, 0x01
  define zACK, 0x06
  define zNAK, 0x15
  define zCAN, 0x18

  define zREQUEST,  0x00
  define zRESPONSE, 0x01

  define zFUNC_ID_SERIAL_API_GET_INIT_DATA,       0x02
  define zFUNC_ID_SERIAL_API_GET_CAPABILITIES,    0x07
  define zFUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES, 0x05
  define zFUNC_ID_ZW_GET_VERSION,                 0x15
  define zFUNC_ID_ZW_MEMORY_GET_ID,               0x20
  define zFUNC_ID_ZW_GET_NODE_PROTOCOL_INFO,      0x41    # Get protocol info (baud rate, listening, etc.) for a given node
  define zFUNC_ID_ZW_GET_VIRTUAL_NODES,           0xA5    # Return all virtual nodes
  # define zFUNC_ID_ZW_IS_VIRTUAL_NODE,             0xA6    # Virtual node test


  # //#define MAX_TRIES     3   // Retry sends up to 3 times
  # #define MAX_TRIES       1   // set this to one, as I believe now that a ACK failure is indication that the device is offline, hence additional attempts will not work.
  # #define MAX_MAX_TRIES       7   // Don't exceed this retry limit
  # #define ACK_TIMEOUT 1000        // How long to wait for an ACK
  # #define BYTE_TIMEOUT    150
  # //#define RETRY_TIMEOUT 40000       // Retry send after 40 seconds
  # #define RETRY_TIMEOUT   10000       // Retry send after 10 seconds (we might need to keep this below 10 for Security CC to function correctly)
  #
  # #define NUM_NODE_BITFIELD_BYTES                         29      // 29 bytes = 232 bits, one for each possible node in the network.
  #
  # #define ZW_CLOCK_SET                                    0x30
  #
  # #define TRANSMIT_OPTION_ACK                             0x01
  # #define TRANSMIT_OPTION_LOW_POWER                       0x02
  # #define TRANSMIT_OPTION_AUTO_ROUTE                      0x04
  # #define TRANSMIT_OPTION_NO_ROUTE                        0x10
  # #define TRANSMIT_OPTION_EXPLORE                         0x20
  #
  # #define TRANSMIT_COMPLETE_OK                            0x00
  # #define TRANSMIT_COMPLETE_NO_ACK                        0x01
  # #define TRANSMIT_COMPLETE_FAIL                          0x02
  # #define TRANSMIT_COMPLETE_NOT_IDLE                      0x03
  # #define TRANSMIT_COMPLETE_NOROUTE                       0x04
  #
  # define zRECEIVE_STATUS_ROUTED_BUSY,                      0x01
  # define zRECEIVE_STATUS_TYPE_BROAD,                       0x04
  #
  define zFUNC_ID_SERIAL_API_GET_INIT_DATA,                0x02
  define zFUNC_ID_SERIAL_API_APPL_NODE_INFORMATION,        0x03
  define zFUNC_ID_APPLICATION_COMMAND_HANDLER,             0x04
  define zFUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES,          0x05
  define zFUNC_ID_SERIAL_API_SET_TIMEOUTS,                 0x06
  define zFUNC_ID_SERIAL_API_GET_CAPABILITIES,             0x07
  define zFUNC_ID_SERIAL_API_SOFT_RESET,                   0x08
  #
  # #define FUNC_ID_ZW_SEND_NODE_INFORMATION                0x12
  # #define FUNC_ID_ZW_SEND_DATA                            0x13
  # #define FUNC_ID_ZW_GET_VERSION                          0x15
  # #define FUNC_ID_ZW_R_F_POWER_LEVEL_SET                  0x17
  # #define FUNC_ID_ZW_GET_RANDOM                           0x1c
  # #define FUNC_ID_ZW_MEMORY_GET_ID                        0x20
  # #define FUNC_ID_MEMORY_GET_BYTE                         0x21
  # #define FUNC_ID_ZW_READ_MEMORY                          0x23
  #
  # #define FUNC_ID_ZW_SET_LEARN_NODE_STATE                 0x40    // Not implemented
  # #define FUNC_ID_ZW_GET_NODE_PROTOCOL_INFO               0x41    // Get protocol info (baud rate, listening, etc.) for a given node
  # #define FUNC_ID_ZW_SET_DEFAULT                          0x42    // Reset controller and node info to default (original) values
  # #define FUNC_ID_ZW_NEW_CONTROLLER                       0x43    // Not implemented
  # #define FUNC_ID_ZW_REPLICATION_COMMAND_COMPLETE         0x44    // Replication send data complete
  # #define FUNC_ID_ZW_REPLICATION_SEND_DATA                0x45    // Replication send data
  # #define FUNC_ID_ZW_ASSIGN_RETURN_ROUTE                  0x46    // Assign a return route from the specified node to the controller
  # #define FUNC_ID_ZW_DELETE_RETURN_ROUTE                  0x47    // Delete all return routes from the specified node
  # #define FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE         0x48    // Ask the specified node to update its neighbors (then read them from the controller)
  # #define FUNC_ID_ZW_APPLICATION_UPDATE                   0x49    // Get a list of supported (and controller) command classes
  # #define FUNC_ID_ZW_ADD_NODE_TO_NETWORK                  0x4a    // Control the addnode (or addcontroller) process...start, stop, etc.
  # #define FUNC_ID_ZW_REMOVE_NODE_FROM_NETWORK             0x4b    // Control the removenode (or removecontroller) process...start, stop, etc.
  # #define FUNC_ID_ZW_CREATE_NEW_PRIMARY                   0x4c    // Control the createnewprimary process...start, stop, etc.
  # #define FUNC_ID_ZW_CONTROLLER_CHANGE                    0x4d    // Control the transferprimary process...start, stop, etc.
  # #define FUNC_ID_ZW_SET_LEARN_MODE                       0x50    // Put a controller into learn mode for replication/ receipt of configuration info
  # #define FUNC_ID_ZW_ASSIGN_SUC_RETURN_ROUTE              0x51    // Assign a return route to the SUC
  # #define FUNC_ID_ZW_ENABLE_SUC                           0x52    // Make a controller a Static Update Controller
  # #define FUNC_ID_ZW_REQUEST_NETWORK_UPDATE               0x53    // Network update for a SUC(?)
  # #define FUNC_ID_ZW_SET_SUC_NODE_ID                      0x54    // Identify a Static Update Controller node id
  # #define FUNC_ID_ZW_DELETE_SUC_RETURN_ROUTE              0x55    // Remove return routes to the SUc
  # #define FUNC_ID_ZW_GET_SUC_NODE_ID                      0x56    // Try to retrieve a Static Update Controller node id (zero if no SUC present)
  # #define FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE_OPTIONS 0x5a    // Allow options for request node neighbor update
  # #define FUNC_ID_ZW_EXPLORE_REQUEST_INCLUSION            0x5e    // supports NWI
  # #define FUNC_ID_ZW_REQUEST_NODE_INFO                    0x60    // Get info (supported command classes) for the specified node
  # #define FUNC_ID_ZW_REMOVE_FAILED_NODE_ID                0x61    // Mark a specified node id as failed
  # #define FUNC_ID_ZW_IS_FAILED_NODE_ID                    0x62    // Check to see if a specified node has failed
  # #define FUNC_ID_ZW_REPLACE_FAILED_NODE                  0x63    // Remove a failed node from the controller's list (?)
  # #define FUNC_ID_ZW_GET_ROUTING_INFO                     0x80    // Get a specified node's neighbor information from the controller
  # #define FUNC_ID_SERIAL_API_SLAVE_NODE_INFO              0xA0    // Set application virtual slave node information
  # #define FUNC_ID_APPLICATION_SLAVE_COMMAND_HANDLER       0xA1    // Slave command handler
  # #define FUNC_ID_ZW_SEND_SLAVE_NODE_INFO                 0xA2    // Send a slave node information frame
  # #define FUNC_ID_ZW_SEND_SLAVE_DATA                      0xA3    // Send data from slave
  # #define FUNC_ID_ZW_SET_SLAVE_LEARN_MODE                 0xA4    // Enter slave learn mode
  # #define FUNC_ID_ZW_GET_VIRTUAL_NODES                    0xA5    // Return all virtual nodes
  # #define FUNC_ID_ZW_IS_VIRTUAL_NODE                      0xA6    // Virtual node test
  # #define FUNC_ID_ZW_SET_PROMISCUOUS_MODE                 0xD0    // Set controller into promiscuous mode to listen to all frames
  # #define FUNC_ID_PROMISCUOUS_APPLICATION_COMMAND_HANDLER 0xD1
  #
  # #define ADD_NODE_ANY                                    0x01
  # #define ADD_NODE_CONTROLLER                             0x02
  # #define ADD_NODE_SLAVE                                  0x03
  # #define ADD_NODE_EXISTING                               0x04
  # #define ADD_NODE_STOP                                   0x05
  # #define ADD_NODE_STOP_FAILED                            0x06
  #
  # #define ADD_NODE_STATUS_LEARN_READY                     0x01
  # #define ADD_NODE_STATUS_NODE_FOUND                      0x02
  # #define ADD_NODE_STATUS_ADDING_SLAVE                    0x03
  # #define ADD_NODE_STATUS_ADDING_CONTROLLER               0x04
  # #define ADD_NODE_STATUS_PROTOCOL_DONE                   0x05
  # #define ADD_NODE_STATUS_DONE                            0x06
  # #define ADD_NODE_STATUS_FAILED                          0x07
  #
  # #define REMOVE_NODE_ANY                                 0x01
  # #define REMOVE_NODE_CONTROLLER                          0x02
  # #define REMOVE_NODE_SLAVE                               0x03
  # #define REMOVE_NODE_STOP                                0x05
  #
  # #define REMOVE_NODE_STATUS_LEARN_READY                  0x01
  # #define REMOVE_NODE_STATUS_NODE_FOUND                   0x02
  # #define REMOVE_NODE_STATUS_REMOVING_SLAVE               0x03
  # #define REMOVE_NODE_STATUS_REMOVING_CONTROLLER          0x04
  # #define REMOVE_NODE_STATUS_DONE                         0x06
  # #define REMOVE_NODE_STATUS_FAILED                       0x07
  #
  # #define CREATE_PRIMARY_START                            0x02
  # #define CREATE_PRIMARY_STOP                             0x05
  # #define CREATE_PRIMARY_STOP_FAILED                      0x06
  #
  # #define CONTROLLER_CHANGE_START                         0x02
  # #define CONTROLLER_CHANGE_STOP                          0x05
  # #define CONTROLLER_CHANGE_STOP_FAILED                   0x06
  #
  # #define LEARN_MODE_STARTED                              0x01
  # #define LEARN_MODE_DONE                                 0x06
  # #define LEARN_MODE_FAILED                               0x07
  # #define LEARN_MODE_DELETED                              0x80
  #
  # #define REQUEST_NEIGHBOR_UPDATE_STARTED                 0x21
  # #define REQUEST_NEIGHBOR_UPDATE_DONE                    0x22
  # #define REQUEST_NEIGHBOR_UPDATE_FAILED                  0x23
  #
  # #define FAILED_NODE_OK                                  0x00
  # #define FAILED_NODE_REMOVED                             0x01
  # #define FAILED_NODE_NOT_REMOVED                         0x02
  #
  # #define FAILED_NODE_REPLACE_WAITING                     0x03
  # #define FAILED_NODE_REPLACE_DONE                        0x04
  # #define FAILED_NODE_REPLACE_FAILED                      0x05
  #
  # #define FAILED_NODE_REMOVE_STARTED                      0x00
  # #define FAILED_NODE_NOT_PRIMARY_CONTROLLER              0x02
  # #define FAILED_NODE_NO_CALLBACK_FUNCTION                0x04
  # #define FAILED_NODE_NOT_FOUND                           0x08
  # #define FAILED_NODE_REMOVE_PROCESS_BUSY                 0x10
  # #define FAILED_NODE_REMOVE_FAIL                         0x20
  #
  # #define SUC_UPDATE_DONE                                 0x00
  # #define SUC_UPDATE_ABORT                                0x01
  # #define SUC_UPDATE_WAIT                                 0x02
  # #define SUC_UPDATE_DISABLED                             0x03
  # #define SUC_UPDATE_OVERFLOW                             0x04
  #
  # #define SUC_FUNC_BASIC_SUC                              0x00
  # #define SUC_FUNC_NODEID_SERVER                          0x01
  #
  # #define UPDATE_STATE_NODE_INFO_RECEIVED                 0x84
  # #define UPDATE_STATE_NODE_INFO_REQ_DONE                 0x82
  # #define UPDATE_STATE_NODE_INFO_REQ_FAILED               0x81
  # #define UPDATE_STATE_ROUTING_PENDING                    0x80
  # #define UPDATE_STATE_NEW_ID_ASSIGNED                    0x40
  # #define UPDATE_STATE_DELETE_DONE                        0x20
  # #define UPDATE_STATE_SUC_ID                             0x10
  #
  # #define APPLICATION_NODEINFO_LISTENING                  0x01
  # #define APPLICATION_NODEINFO_OPTIONAL_FUNCTIONALITY     0x02
  #
  # #define SLAVE_ASSIGN_COMPLETE                           0x00
  # #define SLAVE_ASSIGN_NODEID_DONE                        0x01    // Node ID has been assigned
  # #define SLAVE_ASSIGN_RANGE_INFO_UPDATE                  0x02    // Node is doing neighbor discovery
  #
  # #define SLAVE_LEARN_MODE_DISABLE                        0x00    // disable add/remove virtual slave nodes
  # #define SLAVE_LEARN_MODE_ENABLE                         0x01    // enable ability to include/exclude virtual slave nodes
  # #define SLAVE_LEARN_MODE_ADD                            0x02    // add node directly but only if primary/inclusion controller
  # #define SLAVE_LEARN_MODE_REMOVE                         0x03    // remove node directly but only if primary/inclusion controller
  #
  # #define OPTION_HIGH_POWER                               0x80
  # #define OPTION_NWI                                      0x40    // NWI Inclusion
  # //Device request related
  # #define BASIC_SET                                       0x01
  # #define BASIC_REPORT                                    0x03
  #
  # #define COMMAND_CLASS_BASIC                             0x20
  # #define COMMAND_CLASS_CONTROLLER_REPLICATION            0x21
  # #define COMMAND_CLASS_APPLICATION_STATUS                0x22
  # #define COMMAND_CLASS_HAIL                              0x82
  #
  # #endif // _Defs_H
end
