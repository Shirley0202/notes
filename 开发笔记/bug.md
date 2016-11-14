
##bug

Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'NSConcreteMutableAttributedString initWithString:: nil value'

//加载超大的图就会这样
APP[961:273408] Communications error: <OS_xpc_error: <error: 0x3af20654> { count = 1, contents =
	"XPCErrorDescription" => <string: 0x3af20854> { length = 22, contents = "Connection interrupted" }
}>



CGContextDrawImage: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable