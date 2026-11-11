package br.com.projsoft.provafinal.service;

import br.com.projsoft.provafinal.entity.Artigo;
import br.com.projsoft.provafinal.repository.ArtigoRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ArtigoService {
    private final ArtigoRepository artigoRepository;
    public ArtigoService(ArtigoRepository artigoRepository) {
        this.artigoRepository = artigoRepository;
    }
    public Artigo criar(Artigo artigo) {
        return artigoRepository.save(artigo);
    }

    public List<Artigo> listar() {
        return artigoRepository.findAll();
    }

    public boolean deletar(Long id) {
        if(artigoRepository.existsById(id)) {
            artigoRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
