import java.io.File

data class Coordinates3D(val x: Long, val y: Long, val z: Long) {
}

data class HailStone(val position: Coordinates3D, val velocity: Coordinates3D) {
    fun velocityYPerX(): Double {
        return velocity.y.toDouble() / velocity.x.toDouble()
    }

    fun addition(): Double {
        return position.y.toDouble() - velocityYPerX() * position.x.toDouble()
    }

    fun findCrossingPoint(hailStone: HailStone): Pair<Double, Double> {
        val functionXdifference = this.velocityYPerX() - hailStone.velocityYPerX()
        val thisAddition = this.addition()
        val hailStoneAddition = hailStone.addition()
        val functionsAddition = thisAddition - hailStoneAddition
        val commonX = (functionsAddition / functionXdifference) * -1.0
        val commonY = this.velocityYPerX() * commonX + thisAddition
        return  Pair(commonX, commonY)
    }

    fun checkIfCrossingPointIsInRange(hailStone: HailStone, min: Double, max: Double): Boolean {
        val crossingPoint = findCrossingPoint(hailStone)
        if(crossingPoint.first.isNaN() || crossingPoint.second.isNaN()) {
            return false
        }
        if(crossingPoint.first < this.position.x && this.velocity.x > 0) {
            return false
        }
        if(crossingPoint.first > this.position.x && this.velocity.x < 0) {
            return false
        }
        if(crossingPoint.first < hailStone.position.x && hailStone.velocity.x > 0) {
            return false
        }
        if(crossingPoint.first > hailStone.position.x && hailStone.velocity.x < 0) {
            return false
        }
        if(crossingPoint.second < this.position.y && this.velocity.y > 0) {
            return false
        }
        if(crossingPoint.second > this.position.y && this.velocity.y < 0) {
            return false
        }
        if(crossingPoint.second < hailStone.position.y && hailStone.velocity.y > 0) {
            return false
        }
        if(crossingPoint.second > hailStone.position.y && hailStone.velocity.y < 0) {
            return false
        }
        return crossingPoint.first in min..max && crossingPoint.second in min..max
    }
}

fun main() {
    val lines = File("src/input.txt").readLines()
    val hailStones = mutableListOf<HailStone>()
    for (line in lines) {
        val (positions, velocities) = line.split("@")
        val (x, y, z) = positions.split(",").map { it.trim().toLong() }
        val (vx, vy, vz) = velocities.split(",").map { it.trim().toLong() }
        hailStones.add(HailStone(Coordinates3D(x, y, z), Coordinates3D(vx, vy, vz)))
    }

    var count = 0
    for (i in 0..<hailStones.size) {
        for (j in i + 1..<hailStones.size) {
            if (hailStones[i].checkIfCrossingPointIsInRange(hailStones[j], 200000000000000.0, 400000000000000.0)) {
                count++
            }
        }
    }
    println("Part1: $count")
}