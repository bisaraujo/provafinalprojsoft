package br.com.projsoft.provafinal.controller;

import br.com.projsoft.provafinal.entity.Artigo;
import br.com.projsoft.provafinal.service.ArtigoService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/artigos")
public class ArtigoController {
    private final ArtigoService artigoService;

    public ArtigoController(ArtigoService artigoService) {
        this.artigoService = artigoService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Artigo criar(@Valid @RequestBody Artigo artigo) {
        return artigoService.criar(artigo);
    }

    @GetMapping
    public List<Artigo> listar() {
        return artigoService.listar();
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Long id) {
        artigoService.deletar(id);
    }
}
