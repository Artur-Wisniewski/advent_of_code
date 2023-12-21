import java.io.File

fun openFile(): List<String> {
    val file = File("src/input.txt")
    val lines = file.readLines()
    return lines
}

data class Pulse(val sender: Module, val value: Boolean, val receiver: Module?) {
    fun isLow() = !value
    fun isHigh() = value
}

interface Receiver {
    fun receive(pulse: Pulse)
}

interface Sender {
    fun send(): List<Pulse>
}

interface Module : Sender, Receiver {
    val name: String
    val addressModules: MutableList<Module>
}

class FlipFlop(override val addressModules: MutableList<Module>, override var name: String) : Module {
    private var state = false
    private var previousState = false
    private var isLastPulseHigh = false

    override fun send(): List<Pulse> {
        if (!isLastPulseHigh) {
            if (addressModules.isEmpty()) {
                return listOf(Pulse(this, !previousState, null))
            }
            return addressModules.map { connectedModule -> Pulse(this, !previousState, connectedModule) }.toList()
        }
        return listOf()
    }

    override fun receive(pulse: Pulse) {
        isLastPulseHigh = pulse.isHigh()
        if (pulse.isLow()) {
            previousState = state
            state = !state
        }
    }
}

class Conjunction(
    override val addressModules: MutableList<Module>,
    val senders: MutableList<Sender>,
    override var name: String
) : Module {
    var memory: MutableMap<Sender, Boolean> = mutableMapOf()

    override fun send(): List<Pulse> {
        if (memory.size == senders.size) {
            if (memory.values.all { isHigh -> isHigh }) {
                if (addressModules.isNotEmpty()) {
                    return addressModules.map { addressModule -> Pulse(this, false, addressModule) }.toList()
                } else {
                    return listOf(Pulse(this, false, null))
                }
            }
        }
        if (addressModules.isEmpty()) {
            return listOf(Pulse(this, true, null))
        }
        return addressModules.map { addressModule -> Pulse(this, true, addressModule) }.toList()
    }

    override fun receive(pulse: Pulse) {
        memory.put(pulse.sender, pulse.value)
    }
}

class Broadcaster(override val addressModules: MutableList<Module>, override var name: String) : Module {
    var isHighPulseSent = false

    override fun send(): List<Pulse> {
        if (addressModules.isEmpty()) {
            return listOf(Pulse(this, isHighPulseSent, null))
        }
        return addressModules.map { addressModule -> Pulse(this, isHighPulseSent, addressModule) }.toList()
    }

    override fun receive(pulse: Pulse) {
        isHighPulseSent = pulse.isHigh()
    }
}


fun main() {
    val lines = openFile()
    val modules = mutableListOf<Module>()
    for (line in lines) {
        val (module, _) = line.split(" -> ")
        if (module.contains('%')) {
            modules.add(FlipFlop(mutableListOf<Module>(), module.substring(1)))
        } else if (module.contains('&')) {
            modules.add(Conjunction(mutableListOf<Module>(), mutableListOf<Sender>(), module.substring(1)))
        } else {
            modules.add(Broadcaster(mutableListOf<Module>(), module))
        }
    }
    for (i in 0..<modules.size) {
        val line = lines[i]
        val module = modules[i]
        val (_, connectedModulesText) = line.split(" -> ")
        val addressesNames = connectedModulesText.split(", ")
        val addresses = modules.filter { address -> addressesNames.contains(address.name) }
        if (addresses.isEmpty()) {
            println("empty")
        }
        module.addressModules.addAll(addresses)
    }
    for (module in modules) {
        if (module is Conjunction) {
            for (moduleDeep in modules) {
                if (moduleDeep.addressModules.contains(module)) {
                    module.senders.add(moduleDeep)
                }
            }
        }
    }
    var highPulsesCounter = 0
    var lowPulsesCounter = 0
    for (i in 1..1000) {
        lowPulsesCounter++
        var pulses = modules.find({ module -> module.name == "broadcaster" })!!.send()
        while (pulses.isNotEmpty()) {
            val newPulses = mutableListOf<Pulse>()
            for (pulse in pulses) {
                if (pulse.isHigh()) {
                    highPulsesCounter++
                } else {
                    lowPulsesCounter++
                }
                val receiver = pulse.receiver
                receiver?.receive(pulse)
                val sendPulses = receiver?.send()
                if (sendPulses != null)
                    newPulses.addAll(sendPulses)
            }
            pulses = newPulses
        }
    }
    println("Part 1")
    println("high: $highPulsesCounter low: $lowPulsesCounter")
    println(highPulsesCounter * lowPulsesCounter)
}