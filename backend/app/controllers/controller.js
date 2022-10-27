const db = require("../models");
const Tutorial = db.tutorials;

exports.create = (req, res) => {
    if(!req.body.title) {
        res.status(400).send({ message: "El contenido no puede estar vacío!" });
        return;
    }

    const tutorial = new Tutorial ({
        title: req.body.title,
        description: req.body.description,
        published: req.body.published ? req.body.published : false 
    });

    tutorial
    .save(tutorial)
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        res.status(500).send({
            message:
                err.message || "Algo paso mientras se creaba el contenido"
        });
    });
};

exports.findAll = (req, res) => {
    const title = req.query.title;
    var condition = title ? { title: { $regex: new RegExp(title), $options: "i" } } : {};

    Tutorial.find(condition)
    .then(data => {
        res.send(data);
    })
    .catch(err => {
        res.status(500).send({
            message:
            err.message || "Algo paso mientras se traia el contenido"
        });
    });
};

exports.findOne = (req, res) => {
    const id = req.params.id;

    Tutorial.findById(id)
    .then(data => {
        if(!data)
            res.status(404).send({
                message: "Contenido no encontrado con el id " + id
            });
        else res.send(data);
    })
    .catch(err => {
        res
        .status(500)
        .send({
            message: "Error al obtener el contenido con id " + id
        });
    })
};

exports.update = (req, res) => {
    if (!req.body) {
        return res.status(400).send({
            message: "La información a actualizar no puede estar vacia"
        });
    }

    const id= req.params.id;

    Tutorial.findByIdAndUpdate(id, req.body, { useFindAndModify: false})
    .then(data => {
        if (!data) {
            res.status(404).send({
                message: `No se puede actualizar el contenido con la id=${id}. Tal vez el contenido no existe`
            });
        } else res.send({ message: "El contenido ha sido actualizado"});
    })
    .catch(err => {
        res.status(500).send({
            message: "Error actualizando el contenido con la id=" + id
        });
    });
};

exports.delete = (req, res) => {
    const id = req.params.id;

    Tutorial.findByIdAndRemove(id)
      .then(data => {
        if (!data) {
          res.status(404).send({
            message: `No se puede eliminar el contenido con la id=${id}. Tal vez el contenido no existe!`
          });
        } else {
          res.send({
            message: "El contenido fue eliminado!"
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "No se puede eliminar el contenido con id=" + id
        });
      });
}

exports.deleteAll = (req, res) => {
    Tutorial.deleteMany({})
      .then(data => {
        res.send({
          message: `${data.deletedCount} contenidos eliminados!`
        });
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Algo ha sucedido al eliminar los contenidos"
        });
      });
};

exports.findAllPublished = (req, res) => {
    Tutorial.find({ published: true })
      .then(data => {
        res.send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "No se puede obtener los contenidos publicados."
        });
      });
  };