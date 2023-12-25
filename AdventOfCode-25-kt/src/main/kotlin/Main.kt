package org.example

import org.jgrapht.alg.StoerWagnerMinimumCut
import org.jgrapht.graph.DefaultEdge
import org.jgrapht.graph.SimpleGraph
import java.io.File

fun main() {
    val lines = File("src/main/resources/input.txt").readLines()
    val graph = SimpleGraph<String, DefaultEdge>(DefaultEdge::class.java)
    for(line in lines){
        val (nodeLeft, nodesRight) = line.split(": ")
        val connectedNodes = nodesRight.split(" ")
        graph.addVertex(nodeLeft)
        for(node in connectedNodes){
            graph.addVertex(node)
            graph.addEdge(nodeLeft, node)
        }
    }
    val firstSetOfVertexes = StoerWagnerMinimumCut(graph).minCut().size
    val secondSetOfVertexes = graph.vertexSet().size - firstSetOfVertexes
    println(firstSetOfVertexes * secondSetOfVertexes)
}