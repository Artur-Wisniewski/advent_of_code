import java.io.File
import org.jetbrains.kotlinx.multik.api.linalg.solve
import org.jetbrains.kotlinx.multik.api.mk
import org.jetbrains.kotlinx.multik.api.ndarray
import org.jetbrains.kotlinx.multik.ndarray.data.get
import org.jetbrains.kotlinx.multik.ndarray.operations.sum

data class Coordinates3D(val x: Long, val y: Long, val z: Long) {
}

data class HailStone(val position: Coordinates3D, val velocity: Coordinates3D) {
    private fun velocityYPerX(): Double {
        return velocity.y.toDouble() / velocity.x.toDouble()
    }

    private fun addition(): Double {
        return position.y.toDouble() - velocityYPerX() * position.x.toDouble()
    }

    private fun findCrossingPoint(hailStone: HailStone): Pair<Double, Double> {
        val functionXdifference = this.velocityYPerX() - hailStone.velocityYPerX()
        val thisAddition = this.addition()
        val hailStoneAddition = hailStone.addition()
        val functionsAddition = thisAddition - hailStoneAddition
        val commonX = (functionsAddition / functionXdifference) * -1.0
        val commonY = this.velocityYPerX() * commonX + thisAddition
        return Pair(commonX, commonY)
    }

    fun checkIfCrossingPointIsInRange(hailStone: HailStone, min: Double, max: Double): Boolean {
        val crossingPoint = findCrossingPoint(hailStone)
        if (crossingPoint.first.isNaN() || crossingPoint.second.isNaN()) {
            return false
        }
        if (crossingPoint.first < this.position.x && this.velocity.x > 0) {
            return false
        }
        if (crossingPoint.first > this.position.x && this.velocity.x < 0) {
            return false
        }
        if (crossingPoint.first < hailStone.position.x && hailStone.velocity.x > 0) {
            return false
        }
        if (crossingPoint.first > hailStone.position.x && hailStone.velocity.x < 0) {
            return false
        }
        if (crossingPoint.second < this.position.y && this.velocity.y > 0) {
            return false
        }
        if (crossingPoint.second > this.position.y && this.velocity.y < 0) {
            return false
        }
        if (crossingPoint.second < hailStone.position.y && hailStone.velocity.y > 0) {
            return false
        }
        if (crossingPoint.second > hailStone.position.y && hailStone.velocity.y < 0) {
            return false
        }
        return crossingPoint.first in min..max && crossingPoint.second in min..max
    }
}

fun findRock(hailstones: List<HailStone>): Long {
    val (h1, h2, h3) = hailstones.take(3)
    val a = mk.ndarray(
        mk[
            mk[0, h2.velocity.z - h1.velocity.z, h1.velocity.y - h2.velocity.y, 0, h1.position.z - h2.position.z, h2.position.y - h1.position.y],
            mk[h1.velocity.z - h2.velocity.z, 0, h2.velocity.x - h1.velocity.x, h2.position.z - h1.position.z, 0, h1.position.x - h2.position.x],
            mk[h2.velocity.y - h1.velocity.y, h1.velocity.x - h2.velocity.x, 0, h1.position.y - h2.position.y, h2.position.x - h1.position.x, 0],
            mk[0, h3.velocity.z - h2.velocity.z, h2.velocity.y - h3.velocity.y, 0, h2.position.z - h3.position.z, h3.position.y - h2.position.y],
            mk[h2.velocity.z - h3.velocity.z, 0, h3.velocity.x - h2.velocity.x, h3.position.z - h2.position.z, 0, h2.position.x - h3.position.x],
            mk[h3.velocity.y - h2.velocity.y, h2.velocity.x - h3.velocity.x, 0, h2.position.y - h3.position.y, h3.position.x - h2.position.x, 0],
        ]
    )
    val b = mk.ndarray(
        mk[
            h2.position.y * h2.velocity.z - h2.position.z * h2.velocity.y - h1.position.y * h1.velocity.z + h1.position.z * h1.velocity.y,
            h2.position.z * h2.velocity.x - h2.position.x * h2.velocity.z - h1.position.z * h1.velocity.x + h1.position.x * h1.velocity.z,
            h2.position.x * h2.velocity.y - h2.position.y * h2.velocity.x - h1.position.x * h1.velocity.y + h1.position.y * h1.velocity.x,
            h3.position.y * h3.velocity.z - h3.position.z * h3.velocity.y - h2.position.y * h2.velocity.z + h2.position.z * h2.velocity.y,
            h3.position.z * h3.velocity.x - h3.position.x * h3.velocity.z - h2.position.z * h2.velocity.x + h2.position.x * h2.velocity.z,
            h3.position.x * h3.velocity.y - h3.position.y * h3.velocity.x - h2.position.x * h2.velocity.y + h2.position.y * h2.velocity.x,
        ]
    )
    return mk.linalg.solve(a, b)[0..2].sum().toLong()
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
    println("Part2: ${findRock(hailStones)}")
}