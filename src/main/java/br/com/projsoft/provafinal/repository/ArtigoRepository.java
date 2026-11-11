package br.com.projsoft.provafinal.repository;

import br.com.projsoft.provafinal.entity.Artigo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArtigoRepository extends JpaRepository<Artigo, Long> {
}
